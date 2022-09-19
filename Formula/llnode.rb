class Llnode < Formula
  desc "LLDB plugin for live/post-mortem debugging of node.js apps"
  homepage "https://github.com/nodejs/llnode"
  url "https://github.com/nodejs/llnode/archive/v4.0.0.tar.gz"
  sha256 "abc295c077443f823444faffb165ada4c6ca377f2b1af4c002e8a9eea0f30135"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4559e08d6dcf6a9f0ddfa92fc7fc6ca488d3b0a36e1d4adce527bb759400d779"
    sha256 cellar: :any,                 arm64_big_sur:  "c326383b35e7992e2d866ac897e9421f9b79011ee6ea5fc26779aa5059ac4239"
    sha256 cellar: :any,                 monterey:       "cbf7de9fcf5833ea6172b3fd263f7793f79041b5b2ac380350bd1cd5baab3971"
    sha256 cellar: :any,                 big_sur:        "e2e10b47bf1d3f4bb2c5ecaf868cea6eb870aea40fc2705b0c099cf6b9697a0a"
    sha256 cellar: :any,                 catalina:       "4018c6fe425d6b9ce00ae4a121de9ce17b7962ac1e8d2b32064c154038d3cb64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "085354ed7593c0a7c2bacf20c44a745cf91be1c8d153f827074a49adfaa7a14a"
  end

  depends_on "llvm" => :build
  depends_on "node" => [:build, :test]
  uses_from_macos "llvm"

  def llnode_so(root = lib)
    root/"llnode"/shared_library("llnode")
  end

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    ENV.append_path "PATH", Formula["node"].libexec/"lib/node_modules/npm/node_modules/node-gyp/bin"
    inreplace "Makefile", "node-gyp", "node-gyp.js"

    ENV["LLNODE_LLDB_INCLUDE_DIR"] = Formula["llvm"].opt_include
    system "make", "plugin"
    bin.install "llnode.js" => "llnode"
    llnode_so.dirname.install shared_library("llnode")

    # Needed by the `llnode` script.
    (lib/"node_modules/llnode").install_symlink llnode_so
  end

  def caveats
    llnode = llnode_so(opt_lib)
    <<~EOS
      `brew install llnode` does not link the plugin to LLDB PlugIns dir.

      To load this plugin in LLDB, one will need to either

      * Type `plugin load #{llnode}` on each run of lldb
      * Install plugin into PlugIns dir manually (macOS only):

          mkdir -p "$HOME/Library/Application Support/LLDB/PlugIns"
          ln -sf '#{llnode}' "$HOME/Library/Application Support/LLDB/PlugIns/"
    EOS
  end

  test do
    lldb_out = pipe_output "lldb", <<~EOS
      plugin load #{llnode_so}
      help v8
      quit
    EOS
    assert_match "v8 bt", lldb_out

    llnode_out = pipe_output bin/"llnode", <<~EOS
      help v8
      quit
    EOS
    assert_match "v8 bt", llnode_out
  end
end

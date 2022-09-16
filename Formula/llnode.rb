class Llnode < Formula
  desc "LLDB plugin for live/post-mortem debugging of node.js apps"
  homepage "https://github.com/nodejs/llnode"
  url "https://github.com/nodejs/llnode/archive/v3.3.0.tar.gz"
  sha256 "5bb6d2400be406b660a1b7500e5dd820dc4bed2ae61fd9b4bdf9ab9c7019a789"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3b83445627d4e1e35aab418fbfba37303e72210b0a4c28ec8126616ef435cedd"
    sha256 cellar: :any,                 arm64_big_sur:  "59c65b8dc37b82052e1ffe3ce845b975c04f0fd5a0a96ce75cc4d9f906239243"
    sha256 cellar: :any,                 monterey:       "822b3b017c7ff2c3c2b1ef1b31c86695dfeb69a48afc9c342b0721bcb7c80abe"
    sha256 cellar: :any,                 big_sur:        "a82631c8b56f17bea8cf3f8e5f5077607d59ac52c743058bd1d150ff5e61ad2e"
    sha256 cellar: :any,                 catalina:       "560fa7f91b9efca4de97feffe3bec3ee218eca2786df2a2e473009ab520f855b"
    sha256 cellar: :any,                 mojave:         "23c5930b1c3a4d3d9be6c410dc745014544331af8394917ecd9a928064d7ff49"
    sha256 cellar: :any,                 high_sierra:    "33842b20f13a721a880810a50422bfbf25b8c20a12f5e4882453939e7203ff1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7ec466d2950af84ec1bd3afb5f1170592cca5458b15eaec2d05f70d6b23d110"
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

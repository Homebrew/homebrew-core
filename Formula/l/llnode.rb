class Llnode < Formula
  desc "LLDB plugin for live/post-mortem debugging of node.js apps"
  homepage "https://github.com/nodejs/llnode"
  url "https://github.com/nodejs/llnode/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "abc295c077443f823444faffb165ada4c6ca377f2b1af4c002e8a9eea0f30135"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "587328e971d8e18f42e15a58c9d1c94efe7cc2e48663d34de95e19a2921f7179"
    sha256 cellar: :any,                 arm64_sequoia:  "33bb56546706b569104a07631b10c2b57fd0c6a95ddb5cfc8fed017856e2f57a"
    sha256 cellar: :any,                 arm64_sonoma:   "7215a957ceb5664321af92bfcc1b8cc9e42ae9911a7b91ffacbd9127270b1552"
    sha256 cellar: :any,                 arm64_ventura:  "c11ee956c445277d3a77bfe5ab6b3fa9553c922aabf22731af6e2135d1c2b361"
    sha256 cellar: :any,                 arm64_monterey: "e1c93fd5aefebd887138fd244b50db737433cc30c278c6d18a3e87f0d6316f29"
    sha256 cellar: :any,                 arm64_big_sur:  "a86c196564ac07429bc188fbeb4780d408865721cc7e929e9aceaf24f8e79109"
    sha256 cellar: :any,                 sonoma:         "3551ad8a5cc42a007da92190d786a92e3aacffa7c017ada497ddaef17dd3ab69"
    sha256 cellar: :any,                 ventura:        "ec584fb90528046e31353b134abf6e017a72da189ff394a72d3d9e1affc6b9f6"
    sha256 cellar: :any,                 monterey:       "0737158c515f49e2cb56c68df835f789daa8d13f5b85a9a300532078318a86e5"
    sha256 cellar: :any,                 big_sur:        "fb32b0d19ff9f0c760a79bafdc830f0574a85165601ab493a9b8c7737e5dfef7"
    sha256 cellar: :any,                 catalina:       "d8d1926e4447e8a07e56744001bccd5661fce6186fbb33e75218d11bf57c4908"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6259affcb6b5e18c934eae0510775580d184ca9e1e9a3c4a19c19400bdcb10b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "343c83b8b3a42ad4496c3866dda8da056a4cea95a09bebdec3280cbe3c301484"
  end

  depends_on "llvm" => :build
  depends_on "node" => [:build, :test]
  depends_on "llvm" => :test if DevelopmentTools.clang_build_version == 1403
  uses_from_macos "llvm"

  def llnode_so(root = lib)
    root/"llnode"/shared_library("llnode")
  end

  def install
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
    ENV.prepend_path "PATH", Formula["llvm"].opt_bin if DevelopmentTools.clang_build_version == 1403
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

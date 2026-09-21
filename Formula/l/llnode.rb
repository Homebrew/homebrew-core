class Llnode < Formula
  desc "LLDB plugin for live/post-mortem debugging of node.js apps"
  homepage "https://github.com/nodejs/llnode"
  url "https://github.com/nodejs/llnode/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "abc295c077443f823444faffb165ada4c6ca377f2b1af4c002e8a9eea0f30135"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "773fcfb71dbc8965cb0b0a460ca1bb3480ccd92bbd05afa45847dc855e83b8b0"
    sha256 cellar: :any, arm64_tahoe:       "54c5851be0beb8120052a165ed72dd8476e567abb3f2de41c1c9b428df5d8f75"
    sha256 cellar: :any, arm64_sequoia:     "e65ad5f5498e21f7996650ba55c4fda69e6238965481761a8d363c473a4a5087"
    sha256 cellar: :any, arm64_sonoma:      "3bd820e0cde64034c641b5499152deeb7b8f91986069ddf742b9f5160f9c1df2"
    sha256 cellar: :any, sonoma:            "137619f190f0e99a585f54c88439541af85d196ea1dd92040e2152fb64efec67"
    sha256 cellar: :any, arm64_linux:       "abc726d75152922c80e84dd621881c0c25df7b170b1863a79644f37b88d518fa"
    sha256 cellar: :any, x86_64_linux:      "706bce498263aae2bf30fbf685a4fedc92dabaf135172cfdd58db0998176ab13"
  end

  depends_on "lldb" => :build
  depends_on "node" => [:build, :test]

  uses_from_macos "lldb"

  def llnode_so(root = lib)
    root/"llnode"/shared_library("llnode")
  end

  def install
    ENV.append_path "PATH", formula_opt_libexec("node")/"lib/node_modules/npm/node_modules/node-gyp/bin"
    inreplace "Makefile", "node-gyp", "node-gyp.js"

    ENV["LLNODE_LLDB_INCLUDE_DIR"] = formula_opt_include("lldb")
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

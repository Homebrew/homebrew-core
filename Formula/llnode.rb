class Llnode < Formula
  desc "LLDB plugin for live/post-mortem debugging of node.js apps"
  homepage "https://github.com/indutny/llnode"
  url "https://github.com/indutny/llnode/archive/v1.1.0.tar.gz"
  sha256 "88eeb3293a9b60b3f2299e4263217b2794573e3d2a1113abe2eab37d1c01a7a2"

  bottle do
    cellar :any
    sha256 "dd491bbdb5a73849c1f34493c2b8c7c06eca406e05c8e9744d9a6247aa48c93e" => :el_capitan
    sha256 "a6f1a6eb46a9d6c0d2f3c89c4f75ecd00b59e6b16b541087518fed4bfe5ae189" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on :python => :build

  resource "gyp" do
    url "https://chromium.googlesource.com/external/gyp.git",
        :revision => "db72e9fcf55ba9d8089f0bc7e447180f8972b5c0"
  end

  resource "lldb" do
    url "https://github.com/llvm-mirror/lldb.git",
        :revision => "839b868e2993dcffc7fea898a1167f1cec097a82"
  end

  def install
    (buildpath/"lldb").install resource("lldb")
    (buildpath/"tools/gyp").install resource("gyp")

    system "./gyp_llnode"
    system "make", "-C", "out/"
    prefix.install "out/Release/llnode.dylib"
  end

  def caveats; <<-EOS.undent
    `brew install llnode` does not link the plugin to LLDB PlugIns dir.

    To load this plugin in LLDB, one will need to either

    * Type `plugin load #{opt_prefix}/llnode.dylib` on each run of lldb
    * Install plugin into PlugIns dir manually:

        mkdir -p ~/Library/Application\\ Support/LLDB/PlugIns
        ln -sf #{opt_prefix}/llnode.dylib \\
            ~/Library/Application\\ Support/LLDB/PlugIns/
    EOS
  end

  test do
    lldb_out = pipe_output "lldb", <<-EOS.undent
      plugin load #{opt_prefix}/llnode.dylib
      help v8
      quit
    EOS
    assert_match /v8 bt/, lldb_out
  end
end

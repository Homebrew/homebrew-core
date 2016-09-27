class Llnode < Formula
  desc "LLDB plugin for live/post-mortem debugging of node.js apps"
  homepage "https://github.com/indutny/llnode"
  url "https://github.com/indutny/llnode/archive/v1.2.1.tar.gz"
  sha256 "be3290d3ffd4fae115e62e4f60e029f94b28f4fc5912f619d6732dbbd4178c8b"

  bottle do
    cellar :any
    sha256 "303944ab0881818f0c24e1e71431b14927c2621adab4beff640fc69659de2cfe" => :sierra
    sha256 "0d7c7fab104e495e5f392d900d8f187bb10a99088d63cca6cce5ced042b1a6aa" => :el_capitan
    sha256 "e761fdb6dc583cead747bcce0907d023ac800c18f0d754397187e3018f513874" => :yosemite
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

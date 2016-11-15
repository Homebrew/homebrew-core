class Llnode < Formula
  desc "LLDB plugin for live/post-mortem debugging of node.js apps"
  homepage "https://github.com/indutny/llnode"
  url "https://github.com/indutny/llnode/archive/v1.3.0.tar.gz"
  sha256 "7d7a0c44195adeb0389641148597dfef652ca3736af8bcc90c65e28a0b2ede63"

  bottle do
    cellar :any
    sha256 "65e32e4d06c6b723e72d4aba33b52951a5d63e67be62e86239d868ee91ac5b99" => :sierra
    sha256 "f5866596527a38fef360a7ac31c13a467036ccf6ae7ff7707f5ea97d72f844b9" => :el_capitan
    sha256 "b6f9b1259d58d339ae1c017db19324ea965022e2dc1525c5fa6841cb5d08a79b" => :yosemite
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

class Llnode < Formula
  desc "LLDB plugin for live/post-mortem debugging of node.js apps"
  homepage "https://github.com/indutny/llnode"
  url "https://github.com/indutny/llnode/archive/v1.0.0.tar.gz"
  sha256 "fcf90201930e52b49d0fa1b369aac7b5b74c3bbffe34f423d5aa5b899267f295"

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
    cp "out/Release/llnode.dylib", "#{prefix}/llnode.dylib"
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

class Llnode < Formula
  desc "LLDB plugin for live/post-mortem debugging of node.js apps"
  homepage "https://github.com/nodejs/llnode"
  url "https://github.com/nodejs/llnode/archive/v1.6.2.tar.gz"
  sha256 "d5e979812f7e4ec62b451beb30770dcb8c7f7184fe8816fc6a13ba2b35c1b919"

  bottle do
    cellar :any
    sha256 "cb965fb47971316eb8928157eefd03c9bcdb13387fa9984291e3dd36809845c6" => :high_sierra
    sha256 "cba54eddd2cbc47a628a1163f5d02bea21bd7759e95f7c3c905142d4a8fb757a" => :sierra
    sha256 "83c34005044ba77217d0c9415268a9fa72392213191fe474d8cca0b8f68957a8" => :el_capitan
  end

  depends_on "python" => :build if MacOS.version <= :snow_leopard
  depends_on :macos => :yosemite

  resource "gyp" do
    url "https://chromium.googlesource.com/external/gyp.git",
        :revision => "324dd166b7c0b39d513026fa52d6280ac6d56770"
  end

  resource "lldb" do
    if DevelopmentTools.clang_build_version >= 802
      # lldb 390
      url "https://github.com/llvm-mirror/lldb.git",
          :revision => "d556e60f02a7404b291d07cac2f27512c73bc743"
    elsif DevelopmentTools.clang_build_version >= 800
      # lldb 360.1
      url "https://github.com/llvm-mirror/lldb.git",
          :revision => "839b868e2993dcffc7fea898a1167f1cec097a82"
    else
      # It claims it to be lldb 350.0 for Xcode 7.3, but in fact it is based
      # of 34.
      # Xcode < 7.3 uses 340.4, so I assume we should be safe to go with this.
      url "http://llvm.org/svn/llvm-project/lldb/tags/RELEASE_34/final/",
          :using => :svn
    end
  end

  def install
    (buildpath/"lldb").install resource("lldb")
    (buildpath/"tools/gyp").install resource("gyp")

    system "./gyp_llnode"
    system "make", "-C", "out/"
    prefix.install "out/Release/llnode.dylib"
  end

  def caveats; <<~EOS
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
    lldb_out = pipe_output "lldb", <<~EOS
      plugin load #{opt_prefix}/llnode.dylib
      help v8
      quit
    EOS
    assert_match "v8 bt", lldb_out
  end
end

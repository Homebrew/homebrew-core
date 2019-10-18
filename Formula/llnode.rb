class Llnode < Formula
  desc "LLDB plugin for live/post-mortem debugging of node.js apps"
  homepage "https://github.com/nodejs/llnode"
  url "https://github.com/nodejs/llnode/archive/v2.2.0.tar.gz"
  sha256 "fb1ef8eddc67abcbd5c65f6b6a712b3ff4948814539f1313eed7cd3b58d60fb3"

  bottle do
    cellar :any
    sha256 "9b46a438bd683a821468b2ebe7f579af4a318b131ca853516dba98a5e4d66d93" => :catalina
    sha256 "bd25f25283d4da121c4b64a34ffa060f46e20efbdd463b8af088ed1568cf64ca" => :mojave
    sha256 "5e3d8bfdcafce47c4f36da32a4820b0970020459e8a22d0d28eb3d38fd1c89f3" => :high_sierra
    sha256 "fc975b5e0cb5ee39039100a8da42db92e3359e3e5e3b6c2465e4e969dbee0e7d" => :sierra
  end

  depends_on "node" => :build
  depends_on "python@2" => :build
  depends_on :macos => :yosemite

  resource "lldb" do
    if DevelopmentTools.clang_build_version >= 1000
      # lldb release_60 branch tip of tree commit from 10 Apr 2018
      url "https://github.com/llvm-mirror/lldb.git",
          :revision => "b6df24ff1b258b18041161b8f32ac316a3b5d8d9"
    elsif DevelopmentTools.clang_build_version >= 900
      # lldb release_40 branch tip of tree commit from 12 Jan 2017
      url "https://github.com/llvm-mirror/lldb.git",
          :revision => "fcd2aac9f179b968a20cf0231c3386dcef8a6659"
    elsif DevelopmentTools.clang_build_version >= 802
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
      url "https://llvm.org/svn/llvm-project/lldb/tags/RELEASE_34/final/",
          :using => :svn
    end
  end

  def install
    ENV.append_path "PATH", "#{Formula["node"].libexec}/lib/node_modules/npm/node_modules/node-gyp/bin"
    inreplace "Makefile", "node-gyp", "node-gyp.js"

    # Make sure the buildsystem doesn't try to download its own copy
    target = if DevelopmentTools.clang_build_version >= 900
      "lldb-3.9"
    elsif DevelopmentTools.clang_build_version >= 802
      "lldb-3.8"
    else
      "lldb-3.4"
    end
    (buildpath/target).install resource("lldb")

    system "make", "plugin"
    prefix.install "llnode.dylib"
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

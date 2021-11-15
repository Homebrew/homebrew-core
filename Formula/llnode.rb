class Llnode < Formula
  desc "LLDB plugin for live/post-mortem debugging of node.js apps"
  homepage "https://github.com/nodejs/llnode"
  url "https://github.com/nodejs/llnode/archive/v3.2.0.tar.gz"
  sha256 "499b970a5006c2e1057f6c61da79b5466715e830e4a91c71e6de9c1ff6fe1a52"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "3b83445627d4e1e35aab418fbfba37303e72210b0a4c28ec8126616ef435cedd"
    sha256 cellar: :any, arm64_big_sur:  "59c65b8dc37b82052e1ffe3ce845b975c04f0fd5a0a96ce75cc4d9f906239243"
    sha256 cellar: :any, monterey:       "822b3b017c7ff2c3c2b1ef1b31c86695dfeb69a48afc9c342b0721bcb7c80abe"
    sha256 cellar: :any, big_sur:        "a82631c8b56f17bea8cf3f8e5f5077607d59ac52c743058bd1d150ff5e61ad2e"
    sha256 cellar: :any, catalina:       "560fa7f91b9efca4de97feffe3bec3ee218eca2786df2a2e473009ab520f855b"
    sha256 cellar: :any, mojave:         "23c5930b1c3a4d3d9be6c410dc745014544331af8394917ecd9a928064d7ff49"
    sha256 cellar: :any, high_sierra:    "33842b20f13a721a880810a50422bfbf25b8c20a12f5e4882453939e7203ff1d"
  end

  depends_on "node" => :build
  depends_on "python@3.9" => :build

  resource "lldb" do
    if DevelopmentTools.clang_build_version >= 1000
      # lldb release_60 branch tip of tree commit from 10 Apr 2018
      url "https://github.com/llvm-mirror/lldb.git",
          revision: "b6df24ff1b258b18041161b8f32ac316a3b5d8d9"
    elsif DevelopmentTools.clang_build_version >= 900
      # lldb release_40 branch tip of tree commit from 12 Jan 2017
      url "https://github.com/llvm-mirror/lldb.git",
          revision: "fcd2aac9f179b968a20cf0231c3386dcef8a6659"
    elsif DevelopmentTools.clang_build_version >= 802
      # lldb 390
      url "https://github.com/llvm-mirror/lldb.git",
          revision: "d556e60f02a7404b291d07cac2f27512c73bc743"
    elsif DevelopmentTools.clang_build_version >= 800
      # lldb 360.1
      url "https://github.com/llvm-mirror/lldb.git",
          revision: "839b868e2993dcffc7fea898a1167f1cec097a82"
    else
      # It claims it to be lldb 350.0 for Xcode 7.3, but in fact it is based
      # of 34.
      # Xcode < 7.3 uses 340.4, so I assume we should be safe to go with this.
      url "https://llvm.org/svn/llvm-project/lldb/tags/RELEASE_34/final/", using: :svn
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

  def caveats
    <<~EOS
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

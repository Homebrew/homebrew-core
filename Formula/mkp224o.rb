class Mkp224o < Formula
  desc "Vanity address generator for tor onion v3 (ed25519) hidden services"
  homepage "https://github.com/cathugger/mkp224o"
  url "https://github.com/cathugger/mkp224o/releases/download/v1.6.1/mkp224o-1.6.1-src.tar.gz"
  sha256 "772d4b429c08f04eca3bc45cd3f6ce57b71fa912fa6c061cd39f73bf2fec8e70"
  license "CC0-1.0"
  head "https://github.com/cathugger/mkp224o.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "168d1f78395804cde88bc0ad7c087c18ed1b8d3d986efd4f9ab77cb7cefe944d"
    sha256 cellar: :any,                 arm64_monterey: "5fd449e1ed8792a81732494b7362c75507fa96567b5b1248c76522193762a3d0"
    sha256 cellar: :any,                 arm64_big_sur:  "77672818a99d4b11411863bd952acf9472b1b2b89415839c41600c8c7bae3cfd"
    sha256 cellar: :any,                 ventura:        "2385ca2636a695be5689171e96f562355d3055386166855549bafb512d07cb56"
    sha256 cellar: :any,                 monterey:       "3cef4d9204063c22271e2faca7e67b7b603ba5c2e4270431933d6715b7048dd7"
    sha256 cellar: :any,                 big_sur:        "a3766fdff5c7010b3995300f688a0545961a19bec4137aad2c5304d3f849da85"
    sha256 cellar: :any,                 catalina:       "4133de045c807282326009a66f7bc1d5e56be43d75cd2be4201ac450391add06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13c559ae3f988d2a848f7932862b22a03820ce0f2d1409d67c96c41762a74b16"
  end

  depends_on "libsodium"

  def install
    system "./configure", *std_configure_args
    system "make"
    bin.install "mkp224o"
  end

  test do
    assert_match "waiting for threads to finish... done", shell_output("#{bin}/mkp224o -n 3 home 2>&1")
  end
end

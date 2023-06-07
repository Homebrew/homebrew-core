class Bzip3 < Formula
  desc "Better and stronger spiritual successor to BZip2"
  homepage "https://github.com/kspalaiologos/bzip3"
  url "https://github.com/kspalaiologos/bzip3/releases/download/1.3.1/bzip3-1.3.1.tar.gz"
  sha256 "0361b72da62d2f2e24456be568b9e2a58b5bd0e9fd23f92d9173d1b2e3b4c3d8"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bb6f0f1156a6c568a8bd6f7bc9525add3d3358b0a66142896762a92296090283"
    sha256 cellar: :any,                 arm64_monterey: "e7faa126a5efe0f29a3172b11fdbc4246f1f52f2bccfcfa282012e625e1896d7"
    sha256 cellar: :any,                 arm64_big_sur:  "62f02c1b343c134d95fd869d65ff58e999a8210c6ca866d5d4c80991d09b88e2"
    sha256 cellar: :any,                 ventura:        "2a450c2240796b4813d6c3582da18c97c9e2b1c368378c5e26a7dc6c2f255267"
    sha256 cellar: :any,                 monterey:       "1fc9eccfdffc1f661addc8bf419f2d38eec0065086823886ff476f0e40801690"
    sha256 cellar: :any,                 big_sur:        "707c7b3c8e4fad49df3ae15269e715476c56f5994acc5b1a5f9e3206df98e73e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb983260b781857ee240380531287a49ca866a318a2f80a08d1f09aa1d04bf45"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--disable-arch-native"
    system "make", "install"
  end

  test do
    testfilepath = testpath + "sample_in.txt"
    zipfilepath = testpath + "sample_in.txt.bz3"

    testfilepath.write "TEST CONTENT"

    system bin/"bzip3", testfilepath
    system bin/"bunzip3", "-f", zipfilepath

    assert_equal "TEST CONTENT", testfilepath.read
  end
end

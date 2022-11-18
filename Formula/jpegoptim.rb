class Jpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/v1.5.0.tar.gz"
  sha256 "67b0feba73fd72f0bd383f25bf84149a73378d34c0c25bc0b9b25b0264d85824"
  license "GPL-3.0-or-later"
  head "https://github.com/tjko/jpegoptim.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0685110ec476b42334f2f073a2081e966393d639eb8094b1c2352cb5bb8c27fe"
    sha256 cellar: :any,                 arm64_monterey: "a065955f3a71c461b1526ecaa6657878038223a596ef42ecaf56bc0697147081"
    sha256 cellar: :any,                 arm64_big_sur:  "2644d6450068596ae2a52fcde92be5292a69e2cc0dd96208a36213aed7f53e07"
    sha256 cellar: :any,                 ventura:        "713bf5260a864a3950fc8c0f6c4eff22a674c34c06d2098775f99a65e703409e"
    sha256 cellar: :any,                 monterey:       "94ab3fe10229f457b92c4d4afb137d5ac6e26cf6fef1fa6dcb55d05ddb2f5eff"
    sha256 cellar: :any,                 big_sur:        "de3346241e917c201f413363768731aef8eba491e42336ace80af842d0bb8da8"
    sha256 cellar: :any,                 catalina:       "080f3a10875090e6f23a96ecbc29b6d0bb06d80b48044e9b663f8c60ed2def5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dc8cee452107422a698f91ece275e8a69a42b58aa5420ea880b7648c90951cb"
  end

  depends_on "jpeg-turbo"

  def install
    system "./configure", *std_configure_args
    ENV.deparallelize # Install is not parallel-safe
    system "make", "install"
  end

  test do
    source = test_fixtures("test.jpg")
    assert_match "OK", shell_output("#{bin}/jpegoptim --noaction #{source}")
  end
end

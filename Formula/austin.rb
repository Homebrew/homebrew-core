class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v3.1.0.tar.gz"
  sha256 "1d1776350a2a083cbacbd6100e815cb5e4184bcc35517290c8f82e4e78f4ed7f"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08d4e88d3c9120c1a7ac772e0a6721ab3bb22baf4e7b0d290622922b5b327994"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8518c4eba263717f2e9a7ef064a1f8705b9912d5e6f100938bcc39697d37584a"
    sha256 cellar: :any_skip_relocation, monterey:       "2d99b1c5f140bd2acf9307059ef9e5b79449d60e9d29fa735300a001238a9d64"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2e5e713ff069787934d451ef095fa018a76ee0b21b4269ea0ba7ed1660e8e66"
    sha256 cellar: :any_skip_relocation, catalina:       "7902abd05301381f1f335db81b44ecf6659c20d82d957fc13a0989ca07e95eb7"
    sha256 cellar: :any_skip_relocation, mojave:         "a07f0785ccbe654e3351d7ca620e93c40efb520a92be20b3d7b88a62099afe9d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.10" => :test

  def install
    system "autoreconf", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    man1.install "src/austin.1"
  end

  test do
    shell_output(bin/"austin #{Formula["python@3.10"].opt_bin}/python3 -c \"from time import sleep; sleep(1)\"", 37)
  end
end

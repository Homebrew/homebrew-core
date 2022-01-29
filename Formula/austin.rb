class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v3.3.0.tar.gz"
  sha256 "a0dcfee0dffecb00b85a84f3c7befff7e61fd4b504228c1e6ce7bc5af9790506"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b8a24d0ce7618eb414ff833f0243b9337815ce5da3908a26442e0123ef2f3b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d02458c0f25b9571a03697c0853ca65c4fff0d8d12b136accb9f995ea186db2b"
    sha256 cellar: :any_skip_relocation, monterey:       "9813ea951582bc395949ecb56d9239aaab36610fd15910265d3b17588fba32d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b2778178193276c1bb16f3ae3655e187a37c790472c24adee2bf4794f7f51b8"
    sha256 cellar: :any_skip_relocation, catalina:       "14ce3fc17ec66e20adab82505e37717eced9f2a81636de1947c927f239dd6da8"
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

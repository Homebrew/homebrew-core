class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v3.3.0.tar.gz"
  sha256 "a0dcfee0dffecb00b85a84f3c7befff7e61fd4b504228c1e6ce7bc5af9790506"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18990ecfb169a52a27040e31b051eef9f2c1d034b90d89ab5d086328dd78d15a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a304f79e96a69c33804728e72e7c885f4ae1d25541304a855511d0d5b0c91768"
    sha256 cellar: :any_skip_relocation, monterey:       "bbbc651022a8c644c92afef4075b78cf1a63566a44916bfa747292549ba5ae87"
    sha256 cellar: :any_skip_relocation, big_sur:        "3afdf5cdf5444762b760b3df40894b4eaff2ccc0a594faad14f7025711f308ac"
    sha256 cellar: :any_skip_relocation, catalina:       "6297f8f5600476e8953c1966d9a740ba122c686255fff724a2d31932153bfb7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1187414d616c70903d0e75e3743df889e09a6e8d0fad9c96d8a56dda8db77b75"
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

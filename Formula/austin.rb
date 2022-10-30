class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v3.4.1.tar.gz"
  sha256 "e668af1172f0c2f8740bd7d2eed6613e916e97a7cc88aa6b0cf8420055c2bcc1"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dab8db7b1dd16ff66fbca2418a97d417eb52faef357cec251c3572d1073b4fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cecb73317bf7a9d1ddd4d7f2f5f8a77b8e7d67460f053c64b749b8c31aef9652"
    sha256 cellar: :any_skip_relocation, monterey:       "d06f2a100fc20694a37c473afeeb02b15f105f47c3488e7d1c57fc705547d819"
    sha256 cellar: :any_skip_relocation, big_sur:        "89d0b2e60aad15b293af9f078c86d7cdb6c1c1ebd15d5137b76093003d8b4bfb"
    sha256 cellar: :any_skip_relocation, catalina:       "ba5abcfa7d962bb2ef2c0d3737a2387946b54c5ccbb2a6b4fd76a40cbe116f3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff1d5d18203da0ac96a98871b73d53c8c511c55afe8a6c38ab7f6f7a68c359ab"
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
    python = Formula["python@3.10"].opt_bin/"python3.10"
    shell_output(bin/"austin #{python} -c \"from time import sleep; sleep(1)\"", 37)
  end
end

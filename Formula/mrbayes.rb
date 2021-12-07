class Mrbayes < Formula
  desc "Bayesian inference of phylogenies and evolutionary models"
  homepage "https://nbisweden.github.io/MrBayes/"
  url "https://github.com/NBISweden/MrBayes/archive/v3.2.7a.tar.gz"
  sha256 "3eed2e3b1d9e46f265b6067a502a89732b6f430585d258b886e008e846ecc5c6"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/NBISweden/MrBayes.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7ec10b0d029883853ed249d1f67902459eef0b6e4a80271c9be88422370917b4"
    sha256 cellar: :any,                 arm64_big_sur:  "d85976c7cecd8c8344b5345858d61e0da354abd69f189a8666175ef3ee6ae1be"
    sha256 cellar: :any,                 monterey:       "d25a16dece00097ddaeeeba8b094f4baf56bed9e695c310852ad39455d68d800"
    sha256 cellar: :any,                 big_sur:        "3b7d81480c2cbe7dda28cdf4294bb75ef82739df3398882ab51690b00715b7bf"
    sha256 cellar: :any,                 catalina:       "c80eace4ebe7e49e7eda28d53d223a78c0717115bbeea0ab887f06eab98b4d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a1a4c724b79f47549f569ae633dd4d9d6d10586cca5284f15c0f4279d4beced"
  end

  depends_on "pkg-config" => :build
  depends_on "beagle"
  depends_on "open-mpi"

  def install
    system "./configure", *std_configure_args, "--with-mpi=yes"
    system "make", "install"

    doc.install share/"examples/mrbayes" => "examples"
  end

  test do
    cp doc/"examples/primates.nex", testpath
    cmd = "mcmc ngen = 5000; sump; sumt;"
    cmd = "set usebeagle=yes beagledevice=cpu;" + cmd
    inreplace "primates.nex", "end;", cmd + "\n\nend;"
    system bin/"mb", "primates.nex"
  end
end

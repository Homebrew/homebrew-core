class Mrbayes < Formula
  desc "Bayesian inference of phylogenies and evolutionary models"
  homepage "https://nbisweden.github.io/MrBayes/"
  url "https://github.com/NBISweden/MrBayes/archive/v3.2.7a.tar.gz"
  sha256 "3eed2e3b1d9e46f265b6067a502a89732b6f430585d258b886e008e846ecc5c6"
  license "GPL-3.0-or-later"
  head "https://github.com/NBISweden/MrBayes.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "aad1abf1a6f090d69ae755d2cfc260d5c2e65574cbf23c5235e78097daa64e17"
    sha256 cellar: :any,                 monterey:      "d74384286e6d25d36528f53a10758183ed5dec7199c19c744ea4d0b942fce520"
    sha256 cellar: :any,                 big_sur:       "e0027c3fc59ebb71bbab154a03976eac6dbae6c97c665355767298d1d03285af"
    sha256 cellar: :any,                 catalina:      "bc54dc6955c86b3d10ddf446cec0c188c3a8db75505efce4d23b66c24a4dd482"
    sha256 cellar: :any,                 mojave:        "2349b14afaa49d436cca2c23e62643fc75b231d2ce1a3e572fb4be90448c5fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e8b911053a2c454c03e97e1f8ac89cdce178e30cebf49165dc1b53f1e1a6cbb"
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

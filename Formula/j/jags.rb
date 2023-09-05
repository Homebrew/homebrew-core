class Jags < Formula
  desc "Just Another Gibbs Sampler for Bayesian MCMC simulation"
  homepage "https://mcmc-jags.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mcmc-jags/JAGS/4.x/Source/JAGS-4.3.2.tar.gz"
  sha256 "871f556af403a7c2ce6a0f02f15cf85a572763e093d26658ebac55c4ab472fc8"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/JAGS[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c8ba96c00fb39ab7f4c3089238a555e27ce43f6ab60e9b6999584280340ecb21"
    sha256 cellar: :any,                 arm64_monterey: "3f1eacf3e53bf3189c9d196eb6de1d65a05f7e57f9b25d6d160941fe57325825"
    sha256 cellar: :any,                 arm64_big_sur:  "3c606af0d9e40ccd6b0760ded88dc5900c5a8c8c9c5dd0b1a4854a53a804865c"
    sha256 cellar: :any,                 ventura:        "d40f5a21bf78129d3b7f2971599820cd314abc833845cbf26873ca46898354c3"
    sha256 cellar: :any,                 monterey:       "d839d57ae5b36275eef12c902e66b29321085f025795f2c074e5d65eda01f984"
    sha256 cellar: :any,                 big_sur:        "0cd7d7d301775a3efdaa8dc7aa1c10100b7aba983a22a1b08a68a76f8aa0b434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3f035c69478626479915a42deb8a4e329e3eebef4db5ab7f44e7c23dad34958"
  end

  depends_on "gcc" # for gfortran

  on_linux do
    depends_on "openblas"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"model.bug").write <<~EOS
      data {
        obs <- 1
      }
      model {
        parameter ~ dunif(0,1)
        obs ~ dbern(parameter)
      }
    EOS
    (testpath/"script").write <<~EOS
      model in model.bug
      compile
      initialize
      monitor parameter
      update 100
      coda *
    EOS
    system "#{bin}/jags", "script"
  end
end

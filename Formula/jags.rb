class Jags < Formula
  desc "Just Another Gibbs Sampler for Bayesian MCMC simulation"
  homepage "https://mcmc-jags.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mcmc-jags/JAGS/4.x/Source/JAGS-4.3.0.tar.gz"
  sha256 "8ac5dd57982bfd7d5f0ee384499d62f3e0bb35b5f1660feb368545f1186371fc"
  revision 1

  bottle do
    cellar :any
    sha256 "1d4d987b95d6bfd9cb58429d3554e3c94bb54928a70efd8479365f19d9aea161" => :high_sierra
    sha256 "1b91f63724f9027e8948f5d6391900a8def1bebd7983008c50cd8759f3210ceb" => :sierra
    sha256 "1b8494215c7abf398693ba827f3c43bdc7054be58ef8c593a802384c995f8518" => :el_capitan
    sha256 "2a1b02acc3e361549d64d10cee6581d598f78539c91cd715678c810eb6c31fe4" => :yosemite
  end

  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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

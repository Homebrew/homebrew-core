class Jags < Formula
  desc "Just Another Gibbs Sampler for Bayesian MCMC simulation"
  homepage "https://mcmc-jags.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mcmc-jags/JAGS/4.x/Source/JAGS-4.3.0.tar.gz"
  sha256 "8ac5dd57982bfd7d5f0ee384499d62f3e0bb35b5f1660feb368545f1186371fc"
  revision 2

  bottle do
    cellar :any
    sha256 "f40e6af27e11d70df8d967dfdf56b9f51f97b6d7b26922efc1e0a7c564d6a82e" => :catalina
    sha256 "73dd05de303d75d9a252fd9cf40242036d6227d20ff0e40bdad8a9b4fb5ac093" => :mojave
    sha256 "6f3e40e482b03deb728487e3b9c7089d900f1aa518c74de0859a2877833b16b0" => :high_sierra
    sha256 "0651db81905348bb0c48c20529c5bab0d4eb735da50fcc9ec26aef38672cf26f" => :sierra
    sha256 "6c82f61d6cacec46e7863f9b9cb92f33eac63339822fd196e6a029a75dfb01f7" => :el_capitan
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

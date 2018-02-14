class Jags < Formula
  desc "Just Another Gibbs Sampler for Bayesian MCMC simulation"
  homepage "https://mcmc-jags.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mcmc-jags/JAGS/4.x/Source/JAGS-4.3.0.tar.gz"
  sha256 "8ac5dd57982bfd7d5f0ee384499d62f3e0bb35b5f1660feb368545f1186371fc"
  revision 1

  bottle do
    cellar :any
    sha256 "63cd65d1d545e7240d4fff3a2be5795a78808952b39edf94bb6c6ae96b6e6647" => :high_sierra
    sha256 "16837555592d5d29b1d7b62cb2f680f7a16d46946e05e5ec3c9e129c0e577ba0" => :sierra
    sha256 "eeff9d00549785074a04c0c12b1ef0551a4b6787a704f561397bcc0dd8489f2f" => :el_capitan
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

class Jags < Formula
  desc "Just Another Gibbs Sampler for Bayesian MCMC simulation"
  homepage "https://mcmc-jags.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mcmc-jags/JAGS/4.x/Source/JAGS-4.3.0.tar.gz"
  sha256 "8ac5dd57982bfd7d5f0ee384499d62f3e0bb35b5f1660feb368545f1186371fc"

  bottle do
    cellar :any
    sha256 "970d19cdeacd18ba4fe09348cdff25dec0c6307c7f7e6493ab4d17b17e4b5b5b" => :sierra
    sha256 "3a097289424b68d96d21eebaba46c72919d14fd69d696ce2bd879d309dd3a662" => :el_capitan
    sha256 "998b753d66f973ac321b95c73a630ff325e5543f911ad2c66b782bb6d36fa63e" => :yosemite
    sha256 "07da5d6b1faff0492d3e808d08529b1466dada956ce0454fbe89b522e3dfda9f" => :mavericks
  end

  depends_on :fortran

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"model.bug").write <<-EOS.undent
      data {
        obs <- 1
      }
      model {
        parameter ~ dunif(0,1)
        obs ~ dbern(parameter)
      }
    EOS
    (testpath/"script").write <<-EOS.undent
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

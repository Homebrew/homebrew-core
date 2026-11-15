class Jags < Formula
  desc "Just Another Gibbs Sampler for Bayesian MCMC simulation"
  homepage "https://mcmc-jags.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mcmc-jags/JAGS/5.x/Source/JAGS-5.0.1.tar.gz"
  sha256 "0888571b1812c8ce076ad6326c66f96a0ae7762497c346cd7eb32d35a62105d4"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/JAGS[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e5158a007a1c28d0469d29ea32a97377ea1fa9c85f91ee85447274e4e9673387"
    sha256 cellar: :any, arm64_tahoe:       "fc1b94f196773844fae0c4447653ea9795c2d53af57636431286bc971c18346e"
    sha256 cellar: :any, arm64_sequoia:     "a60d2a3e289b45a694e402b4774696558546f51980c13500716398fe3efdfae3"
    sha256 cellar: :any, arm64_linux:       "6cc4fc64a63d61b678ca1e4b2b6da50121dd983166a2d58af591db52e1a4e751"
    sha256 cellar: :any, x86_64_linux:      "7960338f0de0e165d39490a66de7e6da052a669a1ee6948137711e34c9f7371b"
  end

  depends_on "pkgconf" => :build
  depends_on "gcc"
  depends_on "openblas"

  deny_network_access!

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
    system bin/"jags", "script"
  end
end

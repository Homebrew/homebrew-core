class Jags < Formula
  desc "Just Another Gibbs Sampler for Bayesian MCMC simulation"
  homepage "https://mcmc-jags.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mcmc-jags/JAGS/5.x/Source/JAGS-5.0.0.tar.gz"
  sha256 "64fcd4883b8a8ee907722f49366cc9f277477a0647ada61356f17568f84ffff8"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/JAGS[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "031acca06681a15654d1e92e4cbae86bda74afdf7bca008bbba477e9891b1e16"
    sha256 cellar: :any, arm64_sequoia: "dada1c0551217fb5a2350025aebcb39a0f614f111bd8e790f52171f8e8b771c8"
    sha256 cellar: :any, arm64_sonoma:  "e06b69576431f91a3c5019969775c85b1edc42ae8810bc60c9b3be1cc3166aea"
    sha256 cellar: :any, sonoma:        "b2baa11013a652ea6589d7090f7bc1f0c3076b14aebc60f6c8dd0b75c243382b"
    sha256 cellar: :any, arm64_linux:   "eda1429c3030a4b4b5c2d09abe0a0dabcfabec545d780e96efa9562054825094"
    sha256 cellar: :any, x86_64_linux:  "6979dfcf2e6fe33b3728bb2ec145fff22a4a28431241c85a7fcbf638e2d79b33"
  end

  depends_on "pkgconf" => :build
  depends_on "gcc"
  depends_on "openblas"

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

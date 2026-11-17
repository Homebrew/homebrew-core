class Jags < Formula
  desc "Just Another Gibbs Sampler for Bayesian MCMC simulation"
  homepage "https://mcmc-jags.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mcmc-jags/JAGS/5.x/Source/JAGS-5.0.2.tar.gz"
  sha256 "80143e23fc6feca01d4cce440fd8f6aa865a03333ed36baf9e0ce30a8f9e3aea"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/JAGS[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ee9ca81f81bd8cc51c3f6d4922e5c05c9475233d845ce07a2618fec4e46c0cff"
    sha256 cellar: :any, arm64_tahoe:       "3ee5246381f181b375f2797af904507ddf417eedac7bf9aed396f450f53232b8"
    sha256 cellar: :any, arm64_sequoia:     "93bf956341fe1f63ea9b3f37a561e2d9596e30eac6b70a67eff66aff8792c395"
    sha256 cellar: :any, arm64_linux:       "e823118f0deca73ae55ac1ebf7cc4e3d577fa84a1de15610c2a7e1aa785634e4"
    sha256 cellar: :any, x86_64_linux:      "7342cb5489afe2d42f562d14623ea8368b6a579b6dbf281842deb73960040541"
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

class Jags < Formula
  desc "Just Another Gibbs Sampler for Bayesian MCMC simulation"
  homepage "https://mcmc-jags.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mcmc-jags/JAGS/4.x/Source/JAGS-4.3.0.tar.gz"
  sha256 "8ac5dd57982bfd7d5f0ee384499d62f3e0bb35b5f1660feb368545f1186371fc"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/JAGS[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "e2562319bd140af62e154596b8c9f42511c0907d77d0e5ce4b3579f5752af20a"
    sha256 cellar: :any,                 arm64_big_sur:  "ea0be62c30efa7d985684c3295af0fa972596ed029622af0cf409740d3658c2e"
    sha256 cellar: :any,                 monterey:       "a8b0f9f5bcdef8dd9cf4ccff73d2b3076a8e445c4e565e525c2c4ef9f1a5c01c"
    sha256 cellar: :any,                 big_sur:        "72c2e292449224ec4b825399233be7de57fff2b810c7d31d738386c829a53098"
    sha256 cellar: :any,                 catalina:       "11423ce61e9c8c567179c82e03179427ee9161808ff7256ffca47f72030359b7"
    sha256 cellar: :any,                 mojave:         "9e1448b73ba0853385cdfd2861fd273588a6a8557522f0d3073f50154130e900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "291114d6ec1984a0942fe9f7421d481d92ef96e1a510ceaa4391ff88ac11a7e5"
  end

  depends_on "gcc" # for gfortran

  on_linux do
    depends_on "openblas"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

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

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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "cac7a756275255627578b03f0e89c7df5955b516b9b57b0475aaaf30ca5fe932"
    sha256 cellar: :any,                 arm64_sequoia: "de0d1c33eb2f62ec580fb8b76727ba538bfe1f01a802240e3a96c6b7e31e1282"
    sha256 cellar: :any,                 arm64_sonoma:  "a175a6e45539cfd77e34b8404ec1f0000bad131c5fd74f1317c80a9bbfd4396b"
    sha256 cellar: :any,                 arm64_ventura: "809d732b7d3e75338f66314de253d729c80b599d720b3a8ed963552378a949f3"
    sha256 cellar: :any,                 sonoma:        "6018f7174407683c3970770a7ece8fafb940d393ec7361426477cc390e857fcb"
    sha256 cellar: :any,                 ventura:       "16f424522f064867861a0cdd680d2709fe7a8dacf9765876feb831e9c3731be7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f26c887dcbe69d7cec1ab2623118c55ae76ab9ab6e4526925d06835d63a19fb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb7357faec7f40014256713e322f796e39c5600cfe872753b2fc15b9f3dfefd2"
  end

  depends_on "gcc" => :build # for gfortran
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

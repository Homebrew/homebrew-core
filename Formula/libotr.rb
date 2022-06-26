class Libotr < Formula
  desc "Off-The-Record (OTR) messaging library"
  homepage "https://otr.cypherpunks.ca/"
  url "https://otr.cypherpunks.ca/libotr-4.1.1.tar.gz"
  sha256 "8b3b182424251067a952fb4e6c7b95a21e644fbb27fbd5f8af2b2ed87ca419f5"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?libotr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5bec49cd5eed27e30367920033e87d1e40e2857fb3189f3eea37b79e269460ef"
    sha256 cellar: :any,                 arm64_big_sur:  "d3f0dce4e18d75daa3563be158054d7f5c92f4de80e5169dfaf7f9b785deed8d"
    sha256 cellar: :any,                 monterey:       "780996159fd32cfe192acbde0b7a689473a0036b86473d468348e45ca38dcfad"
    sha256 cellar: :any,                 big_sur:        "783eead021ab3ddb3897f8c40e91bd6aec58e5084ef1df3c45a98550591ad29c"
    sha256 cellar: :any,                 catalina:       "b841026a4752756107affe9f6016da14ea5a9a0a48b33ccd461eced5cd89b64a"
    sha256 cellar: :any,                 mojave:         "90da0033157a7771cf7239d038f36e0d613616f1918a168fa763f3e2eafc0106"
    sha256 cellar: :any,                 high_sierra:    "0b340441feba4b325c3ff5c26a9e79b16294461f6f681ae42a2a5d45966e7391"
    sha256 cellar: :any,                 sierra:         "9f0b214278e4cdf81a1a0c083f1aa45ba64430b449121c4d0596357952dcc93d"
    sha256 cellar: :any,                 el_capitan:     "43d7a166cd12b611e7bf15dfa3865d18e573a81a218e2aeb0061d51203ecde39"
    sha256 cellar: :any,                 yosemite:       "b3f215fd3952f7a97af36500365c3c017f23de107162f4c76b0e48355bd2a358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6aa94cf47042090f80a21474fe5e29203fa5cda8e10900b1dc1d4065f93e716f"
  end

  depends_on "libgcrypt"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end

class Makedepend < Formula
  desc "Creates dependencies in makefiles"
  homepage "https://x.org/"
  url "https://xorg.freedesktop.org/releases/individual/util/makedepend-1.0.7.tar.xz"
  sha256 "a729cfd3c0f4e16c0db1da351e7f53335222e058e3434e84f91251fd6d407065"
  license "MIT"

  livecheck do
    url "https://xorg.freedesktop.org/releases/individual/util/"
    regex(/href=.*?makedepend[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ce7360e0dd0d6a2b2f1df05887a099affdb7b3be753f1203d9359905d1ec722"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3ba9a11afac0d23fff0d1e79cb26213a90fa4bc2d07cc1405ec7f1f514bf18a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be8d84dee070f1d7da53aa291443b056136e67906ff29368ba56366d00b5dfc2"
    sha256 cellar: :any_skip_relocation, monterey:       "dc6729e97faabd935de5a8356c00307a39a20c3f037cf67cf09cce9819b392fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "8be31010fad5fc4f86055643bfd592123dbd68ebb4780458dbc40004709504a8"
    sha256 cellar: :any_skip_relocation, catalina:       "afe76789b5f01ccfee8cc0d4ffa308015fb5d8791a1d7ce6b2dc1ee4bf2a020f"
    sha256 cellar: :any_skip_relocation, mojave:         "a25fb9fd3ce11f6b98da2c53fad8f046174697087f5f34664999afb9df5f41de"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0f463e197923867ff9387b2ccd1461d4b410e89205bd3896ae98c5d52679c4c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "740fb92a5e60c325afab7552e81f4b738a833bddf75f11c0efc5f9cda2ca492f"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros"
  depends_on "xorgproto"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          *std_configure_args
    system "make", "install"
  end

  test do
    touch "Makefile"
    system "#{bin}/makedepend"
  end
end

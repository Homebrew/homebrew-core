class Makedepend < Formula
  desc "Creates dependencies in makefiles"
  homepage "https://x.org/"
  url "https://xorg.freedesktop.org/releases/individual/util/makedepend-1.0.6.tar.bz2"
  sha256 "d558a52e8017d984ee59596a9582c8d699a1962391b632bec3bb6804bf4d501c"
  license "MIT"

  livecheck do
    url "https://xorg.freedesktop.org/releases/individual/util/"
    regex(/href=.*?makedepend[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
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

  resource "xproto" do
    url "https://xorg.freedesktop.org/releases/individual/proto/xproto-7.0.31.tar.gz"
    mirror "http://xorg.mirrors.pair.com/individual/proto/xproto-7.0.31.tar.gz"
    sha256 "6d755eaae27b45c5cc75529a12855fed5de5969b367ed05003944cf901ed43c7"
  end

  resource "xorg-macros" do
    url "https://xorg.freedesktop.org/releases/individual/util/util-macros-1.19.2.tar.bz2"
    mirror "http://xorg.mirrors.pair.com/individual/util/util-macros-1.19.2.tar.bz2"
    sha256 "d7e43376ad220411499a79735020f9d145fdc159284867e99467e0d771f3e712"
  end

  def install
    resource("xproto").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{buildpath}/xproto"

      # https://github.com/spack/spack/issues/4805#issuecomment-316130729 build fix for xproto
      ENV.deparallelize { system "make", "install" }
    end

    resource("xorg-macros").stage do
      system "./configure", "--prefix=#{buildpath}/xorg-macros"
      system "make", "install"
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/xproto/lib/pkgconfig"
    ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/xorg-macros/share/pkgconfig"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    touch "Makefile"
    system "#{bin}/makedepend"
  end
end

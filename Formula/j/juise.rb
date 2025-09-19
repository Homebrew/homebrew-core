class Juise < Formula
  desc "JUNOS user interface scripting environment"
  homepage "https://github.com/Juniper/juise/wiki"
  url "https://github.com/Juniper/juise/releases/download/3.0.0/juise-3.0.0.tar.gz"
  sha256 "54d641789bf9a531bc262876914e76888382522ad193eace132d16203546d51e"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "7d7c0ee1120c72a4615a7c3eb947db45c9daf1c841e7e0a6dcadacfbd12e562b"
    sha256 arm64_sequoia: "2013383bad9ecb913d1888a0cb957fa78044bf13aa30ba2a3bf52275d0009c49"
    sha256 arm64_sonoma:  "666efd51556692b16cd32582a0aacf68272c8f5c5bb4315e188f59f73bea6ca4"
    sha256 arm64_ventura: "a13e8825285d6e81d404b71bbced2b2e64b90074077c8862366c1f44acb8e409"
    sha256 sonoma:        "1e3b075c24e4fa37d85fbf1adee7d01520ae0bb37167e13f8d8369431292309f"
    sha256 ventura:       "0c88f52098999814254d35f3a82b7d61d40ab6dea598ff8924be683debc31c66"
  end

  head do
    url "https://github.com/Juniper/juise.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libssh2" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libslax"

  def install
    # Work around undefined symbol ___res_9_state
    ENV.append "LDFLAGS", "-lresolv" if DevelopmentTools.clang_build_version >= 1700

    system "sh", "./bin/setup.sh" if build.head?

    # Prevent sandbox violation where juise's `make install` tries to
    # write to "/usr/local/Cellar/libslax/0.20.1/lib/slax/extensions"
    # Reported 5th May 2016: https://github.com/Juniper/juise/issues/34
    inreplace "configure",
      "SLAX_EXTDIR=\"`$SLAX_CONFIG --extdir | head -1`\"",
      "SLAX_EXTDIR=\"#{lib}/slax/extensions\""

    system "./configure", "--enable-libedit", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "libjuice version #{version}", shell_output("#{bin}/juise -V")
  end
end

class Cadaver < Formula
  desc "Command-line client for DAV"
  homepage "https://notroj.github.io/cadaver/"
  url "https://notroj.github.io/cadaver/cadaver-0.27.tar.gz"
  sha256 "12afc62b23e1291270e95e821dcab0d5746ba4461cbfc84d08c2aebabb2ab54f"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?cadaver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c8c260eea064ab6004f5c647b1820f09e94139f34309eba036392bc95d12f1b1"
    sha256 arm64_sequoia: "9e3056dd09c954bae6f471b03b1ba89f3298eab5f972e0a45749ee2ed0ce6265"
    sha256 arm64_sonoma:  "cc914c3ccfc2d29c98bcd56e848c2b73bc9ac1c13e52c7fd94b7073604e1ee02"
    sha256 arm64_ventura: "7508f868b529213b9a0f2a064578ab9813ebd60c3a3248a84b7a1c9282d0f07a"
    sha256 sonoma:        "a3e1a9c0d52a1b085a5ea19ab326938f87ff1a67f5452a57141aedd39db148a6"
    sha256 ventura:       "14cffe45161927b1b46cdd1ffee087428a5c8eeb18a4d4f048a84eb6b9e81a11"
    sha256 arm64_linux:   "8ed37bdd804521eb9a66f0d35556a13ba0cda1fc996095f1e9e282dc8d0e861d"
    sha256 x86_64_linux:  "a87d9b4c1c7bbd355c46d4ba2335d1ae92a3964f513e21b45ce59ad51e2f21be"
  end

  head do
    url "https://github.com/notroj/cadaver.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "neon"
  depends_on "openssl@3"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  def install
    if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system "./autogen.sh"
    end
    system "./configure", "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl@3"].opt_prefix}",
                          "--with-neon=#{Formula["neon"].opt_prefix}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "cadaver #{version}", shell_output("#{bin}/cadaver -V", 255)
  end
end

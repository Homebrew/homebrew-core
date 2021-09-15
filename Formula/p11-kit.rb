class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.24.0/p11-kit-0.24.0.tar.xz"
  sha256 "81e6140584f635e4e956a1b93a32239acf3811ff5b2d3a5c6094e94e99d2c685"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "08f5b20fdf61c9b8fae57e972c9970aa28f5ef2daa7ea5990e20b02989c49095"
    sha256 big_sur:       "d72ad488a7efacfbd178e3c95fbc2315661cf27071500c05ff267abd196e2970"
    sha256 catalina:      "438735a16afded002578fd553d96047e53fda95de84928e696bd3dda08aee0de"
    sha256 mojave:        "1948f25f27aa1a6978246c644c5c356ea5b4371bf2eabe5b96c378251d5bbeaf"
    sha256 x86_64_linux:  "795988f18b0a393f4e5769c3b55646f7ee236b865489f547c6853ce111073903"
  end

  head do
    url "https://github.com/p11-glue/p11-kit.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"

  def install
    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

    if build.head?
      ENV["NOCONFIGURE"] = "1"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-trust-module",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-module-config=#{etc}/pkcs11/modules",
                          "--without-libtasn1"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end

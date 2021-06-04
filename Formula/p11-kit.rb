class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.24.0/p11-kit-0.24.0.tar.xz"
  sha256 "81e6140584f635e4e956a1b93a32239acf3811ff5b2d3a5c6094e94e99d2c685"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "0cd22f169cd684116fdeb4e52cf551950d1a0c2cced55ee903bf694a0d9d6866"
    sha256 big_sur:       "9474fe6483bbc394d9069f79528ecfe9ba1af00db4aca23c26857b6b66736d73"
    sha256 catalina:      "d02045826811eeb8475b535be7331c0770fdc930d1ac1be86796af81141e8592"
    sha256 mojave:        "4d35cd8fd37b06687b5025354f3a579ab2e36e8ab8bd9bab75102eee14bd86f4"
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

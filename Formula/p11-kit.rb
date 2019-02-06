class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.15/p11-kit-0.23.15.tar.gz"
  sha256 "f7c139a0c77a1f0012619003e542060ba8f94799a0ef463026db390680e4d798"

  bottle do
    sha256 "301934315c4d5c86b324d2278632252e43c196c3850bd3fe783fc4243c3474b5" => :mojave
    sha256 "371b8b98a222467779ee3e4384f3b589144929a52eb5b299dea3e12065303bd5" => :high_sierra
    sha256 "6d84a3f21f5e31ed57dd0d4b3a4fca6d606ef0a74e88c7b782d3dcf3919b3e15" => :sierra
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
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end

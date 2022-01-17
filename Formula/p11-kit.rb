class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.24.1/p11-kit-0.24.1.tar.xz"
  sha256 "d8be783efd5cd4ae534cee4132338e3f40f182c3205d23b200094ec85faaaef8"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "14b8985e80f704dac002c47b4638eeebbd09124a7deeff335206fbf93b7982f5"
    sha256 arm64_big_sur:  "c426b43681464e1f56bf01d13283acda2f042fab95165262f4dc9b6fd02f5eec"
    sha256 monterey:       "6c775d6e28eba867407642b88bca09c562da5ddf7d757cb2fadc5b73a05de90e"
    sha256 big_sur:        "f9178b397c4296bd94f0dfbbe066a57ade3a9b8a6b2ca68e245b9f710314d3e0"
    sha256 catalina:       "3421dfebd2339d981819def1fc61fe01f9e792009f88d60aa572d39cbb2ee5d2"
    sha256 x86_64_linux:   "286a62b3d7192b36c1302d78a3c0aa6f424282db626bf73779233b659328aa0b"
  end

  head do
    url "https://github.com/p11-glue/p11-kit.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "ca-certificates"
  depends_on "libffi"
  depends_on "libtasn1"

  def install
    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

    if build.head?
      ENV["NOCONFIGURE"] = "1"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-module-config=#{etc}/pkcs11/modules",
                          "--with-trust-paths=#{etc}/ca-certificates/cert.pem"
    system "make"
    # This formula is used with crypto libraries, so let's run the test suite.
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end

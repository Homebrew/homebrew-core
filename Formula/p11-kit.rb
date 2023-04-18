class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.24.1/p11-kit-0.24.1.tar.xz"
  sha256 "d8be783efd5cd4ae534cee4132338e3f40f182c3205d23b200094ec85faaaef8"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_ventura:  "390bf08fc2c0a63b200b5cceb8e12d485118ff651936b84a8fe3aed10b06ce56"
    sha256 arm64_monterey: "092795b583a9f4e529eca159e4fbadfb4c92b4af1b62174e0e7882f8a7961908"
    sha256 arm64_big_sur:  "df412a2d8b78365ae59b70e9e0271c0c62d6cb8015d973194e9b8585b3cb577a"
    sha256 ventura:        "611163d62f8575e6738413854f1f3b747304805d0350908dccf80596551bd1af"
    sha256 monterey:       "ce3a6723491c5cee1d79e938b377555b67738b7e4a4615bbc4189624415b15dd"
    sha256 big_sur:        "0a34fda3209d79aa796026de51beb48d6a9d2d0e532c2fcd415371291ef29ce0"
    sha256 catalina:       "5dad56eaeb359e39274bbec47ecb716089eb30b2f69e652287704993a8c97f71"
    sha256 x86_64_linux:   "02b36849258c93af1a99460457fb93da9c2554b8c444fdbbc85c8d38326e0ef7"
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
  depends_on "libtasn1"

  uses_from_macos "libffi", since: :catalina

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

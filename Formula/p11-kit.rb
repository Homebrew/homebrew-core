class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.24.1/p11-kit-0.24.1.tar.xz"
  sha256 "d8be783efd5cd4ae534cee4132338e3f40f182c3205d23b200094ec85faaaef8"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "a1c85ddc587d4b0e6ad38f7b58420ed0fc4a1ccdb038bee1451d9d81fc3fb434"
    sha256 arm64_big_sur:  "c8610976401ff3745b737973335cd2ec7a3113737aadc9e2a1243adf404f41a3"
    sha256 monterey:       "46805ec48a06585f71e5acaa4e099c32696a2dd7700817882211abab75fa3f1d"
    sha256 big_sur:        "6db6726e6ba1314792648413bc991bd717380eb3ae325895750eab515ce5fa75"
    sha256 catalina:       "dc5592e236946f8a3e57998214d13f1c0db7dab5bdd9602bb0c4a84dacf2d17a"
    sha256 x86_64_linux:   "41dd8094535e5cb03c1c4e94290cee3047e79c07183cdccbb0f4f3cbe89d29db"
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

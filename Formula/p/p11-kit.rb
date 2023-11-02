class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.25.2/p11-kit-0.25.2.tar.xz"
  sha256 "44be0f5797464ca5b36c68c8fb9152c2d34e91f6ba910ad3945dd7cdd2557cc3"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "6438272d357e857c57acd0f259c961e3e772c2df508af667ad5600ac75a27ba0"
    sha256 arm64_ventura:  "d6fbea26f747ef6a21db07a5c949bc78586ddd051fe4de3cff5de8a97f35a399"
    sha256 arm64_monterey: "d307b2dfe38e22754acff15a5c8698c07e4ddabfee6e800c29928eeb77db77c8"
    sha256 sonoma:         "8414766fb85604507ee7dc01b9fb9f5286e310a5c6405391c07175fd97687efd"
    sha256 ventura:        "578762d91aff2368c32fe4a80f5dede247cb4e14eaf2dc4173ed451d64febe7d"
    sha256 monterey:       "3b8833b972b7b36a4611764dcfb9179be3bb0e891930a47e0adb2f9d7751f67b"
    sha256 x86_64_linux:   "93064c34732964a5c86f71897336f89d3fab5cdc96e1cc20a2ec2b5104e00c2d"
  end

  head do
    url "https://github.com/p11-glue/p11-kit.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
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

    args = %W[
      -Dsystem_config=#{etc}
      -Dmodule_config=#{etc}/pkcs11/modules
      -Dtrust_paths=#{etc}/ca-certificates/cert.pem"
      -Dsystemd=disabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    # This formula is used with crypto libraries, so let's run the test suite.
    system "meson", "test", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end

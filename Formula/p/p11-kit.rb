class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.25.5/p11-kit-0.25.5.tar.xz"
  sha256 "04d0a86450cdb1be018f26af6699857171a188ac6d5b8c90786a60854e1198e5"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "0e51a00f2618f725240df9d8377198b3556efcefa43cd4c98a63540bc8ce3ef9"
    sha256 arm64_ventura:  "309bd16591d053baa2dde862660603a0e3154567905475cb2e42c453d9340b0c"
    sha256 arm64_monterey: "4d348b82d56c412b5faa07dcc936c0695163d2a22497cbb9b567a70005bf98df"
    sha256 sonoma:         "d125a008ddfc2c79b3a441837878eab2aa5b88e34f7f9b9f35097b40a05884a1"
    sha256 ventura:        "5b2476ef1b255d5ae63df754477a2c812130c2a23ae57ee49dfb0020507add7a"
    sha256 monterey:       "163272d04249838ea2b14275965c85aeb2cef0bebf1249b9df6cdf49e07f2e04"
    sha256 x86_64_linux:   "40b8cebcf82b3183f5103e3447eabf9086eb44ca18bb801c48bb07654a975bc6"
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
    # system "meson", "test", "-C", "build" # this times out
    system "meson", "install", "-C", "build"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end

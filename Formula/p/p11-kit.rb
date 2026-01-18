class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.25.10/p11-kit-0.25.10.tar.xz"
  sha256 "a62a137a966fb3a9bbfa670b4422161e369ddea216be51425e3be0ab2096e408"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "799bb74bf003c38fc6e43d1bfaffa68f2ccca2757b4b5fc297980a640e7369ed"
    sha256 arm64_sequoia: "5c946df0d427b82823e679f14f4462e2f646785b4de0d167ff05e9b368a35a8c"
    sha256 arm64_sonoma:  "94a15ec13c63e887a23b9467525c31906ab7444b81a3088e023d31d248443e4e"
    sha256 sonoma:        "ae3f66252d3f096e99c38031d24ce1241ca306d1fa17f7f921e1d35bec1ef182"
    sha256 arm64_linux:   "16803768e52ac4c5842bc8ac83ddf8da47093997188e9ec2a3ae51b926203878"
    sha256 x86_64_linux:  "17e36f268b12a807d8db88ea301719b927e023b6326e2f15a9a73e1e5ac342b5"
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
  depends_on "pkgconf" => :build
  depends_on "ca-certificates"
  depends_on "libtasn1"

  uses_from_macos "libffi"

  def install
    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

    args = %W[
      -Dsystem_config=#{etc}
      -Dmodule_config=#{etc}/pkcs11/modules
      -Dtrust_paths=#{etc}/ca-certificates/cert.pem
      -Dsystemd=disabled
    ]

    system "meson", "setup", "_build", *args, *std_meson_args
    system "meson", "compile", "-C", "_build", "--verbose"
    # This formula is used with crypto libraries, so let's run the test suite.
    system "meson", "test", "-C", "_build", "--timeout-multiplier=2"
    system "meson", "install", "-C", "_build"

    # HACK: Work around p11-kit: couldn't load module: .../lib/pkcs11/p11-kit-trust.so
    # Issue ref: https://github.com/p11-glue/p11-kit/issues/612
    (lib/"pkcs11").install_symlink "p11-kit-trust.dylib" => "p11-kit-trust.so" if OS.mac?
  end

  test do
    assert_match "library-manufacturer: PKCS#11 Kit", shell_output("#{bin}/p11-kit list-modules --verbose")
  end
end

class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.25.5/p11-kit-0.25.5.tar.xz"
  sha256 "04d0a86450cdb1be018f26af6699857171a188ac6d5b8c90786a60854e1198e5"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "a411c523067edccdf5288ff53f725d590c60d0a182f1e69238fcfc86018f3395"
    sha256 arm64_sonoma:   "844c2f2f63155c6da1a6af44030866700c57981c974f71f4159a6d794e05fcfc"
    sha256 arm64_ventura:  "97ccac96157529edec341b35d57e6ca9579fb25f42d62bb573a1013572101eed"
    sha256 arm64_monterey: "aab401574960e088578df801ab10d600bfe6277f6d174bfc1bf90ea8348529e8"
    sha256 sonoma:         "38423db237bdda5e2485a28e5f30c106f324c440d64a4e10bffb5fc997d91aa6"
    sha256 ventura:        "ab67e4c145d61683447ef09ec9315bd22cc95efa699bbac9e2fc476104a579c0"
    sha256 monterey:       "25fc56254568c72ad22c39c2768ca249992df53a9da2cbeee55ac221f67e1ae3"
    sha256 arm64_linux:    "630a4eaece70b3e7d8d0330018e955ea2ffa3fb84263a48aec0056cef5c2e1cf"
    sha256 x86_64_linux:   "65efc1a95ab97b86e0eb36f2e8782d3f6140d795f3bc33cb6e20267d5fee45f0"
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

  uses_from_macos "libffi", since: :catalina

  def install
    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

    args = %W[
      -Dsystem_config=#{etc}
      -Dmodule_config=#{etc}/pkcs11/modules
      -Dtrust_paths=#{etc}/ca-certificates/cert.pem"
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

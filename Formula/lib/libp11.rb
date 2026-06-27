class Libp11 < Formula
  desc "PKCS#11 wrapper library in C"
  homepage "https://github.com/OpenSC/libp11/wiki"
  url "https://github.com/OpenSC/libp11/releases/download/libp11-0.4.18/libp11-0.4.18.tar.gz"
  sha256 "9292de67ca73aba1deacf577c9086b595765f36ef47712cfeb49fa31f6e772fb"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libp11[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a94d83844bc1f18b84f86706ebf2c352aca06d25600caf40607abf84a6143754"
    sha256 cellar: :any,                 arm64_sequoia: "d2bd6f345624a39294440cecbfc059e545a5dc39a7bab8c8e739755721ac5c31"
    sha256 cellar: :any,                 arm64_sonoma:  "b3cf34f7f345d962fc543d2dba6b9a81a36a8644936dfab1dcc1349b612ebcb8"
    sha256 cellar: :any,                 sonoma:        "74bc484a52d1b9385a0c63d0adc420f34376286b34a5652c53dc6454ec9f2205"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "230793e71d2b7f3b024ed4ebd9644848c5718fde2002ce92b89635ac5cc1a318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31470d470591cdffac76a296ace50dbc0df4a6cbf5210afd2dc40b0e4a0e5f19"
  end

  head do
    url "https://github.com/OpenSC/libp11.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libtool"
  depends_on "openssl@3"

  def install
    openssl = deps.find { |d| d.name.match?(/^openssl/) }
                  .to_formula
    enginesdir = Utils.safe_popen_read("pkgconf", "--variable=enginesdir", "libcrypto").chomp
    enginesdir.sub!(openssl.prefix.realpath, prefix)

    modulesdir = Utils.safe_popen_read("pkgconf", "--variable=modulesdir", "libcrypto").chomp
    modulesdir.sub!(openssl.prefix.realpath, prefix)

    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-enginesdir=#{enginesdir}",
                          "--with-modulesdir=#{modulesdir}",
                          *std_configure_args
    system "make", "install"
    pkgshare.install "examples/auth.c"
  end

  test do
    system ENV.cc, pkgshare/"auth.c", "-I#{Formula["openssl@3"].include}",
                   "-L#{lib}", "-L#{Formula["openssl@3"].lib}",
                   "-lp11", "-lcrypto", "-o", "test"
  end
end

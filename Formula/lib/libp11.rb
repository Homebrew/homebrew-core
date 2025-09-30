class Libp11 < Formula
  desc "PKCS#11 wrapper library in C"
  homepage "https://github.com/OpenSC/libp11/wiki"
  url "https://github.com/OpenSC/libp11/releases/download/libp11-0.4.16/libp11-0.4.16.tar.gz"
  sha256 "97777640492fa9e5831497e5892e291dfbf39a7b119d9cb6abb3ec8c56d17553"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libp11[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2c8918cc325210c860270b30d7df03b0fd99a3b1b7c3ee1b3f4e3f564cef22e0"
    sha256 cellar: :any,                 arm64_sequoia: "b3552045716b3b73091ceca3106ecc3252344c5719d8b79fe72e372bc833c12a"
    sha256 cellar: :any,                 arm64_sonoma:  "5a34df1ff3e44371a025e099d6619163e9f1bbe1c3401cdf457c9d5892745b00"
    sha256 cellar: :any,                 arm64_ventura: "2637f42b811baecfbe34b682c63ad9e2d4945e5bc752cfe1954941060542d814"
    sha256 cellar: :any,                 sonoma:        "616d6d08932fbaa5146558c034ac353078e8c482315f798537ac44a160d11e6e"
    sha256 cellar: :any,                 ventura:       "5ff7176868b03b686d989cf271878741de182d86d77ebf2313bea1e94f95948a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9db183852e3b414c23ee0d2a4c5cb66994c1eb966af3e199cff703b3a5d5db82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "971063937a7ee5f24b7fffcb6d339cd5b7cb713db777d6165c8a47a14fb3bf78"
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

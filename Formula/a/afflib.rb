class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/refs/tags/v3.7.23.tar.gz"
  sha256 "b09334cd690ebe28ef182b00b59a426db662417b90bb9fd4985b11df5654fca4"
  license all_of: [
    "BSD-4-Clause", # AFFLIB 2.0a14 and before
    :public_domain, # contributions after 2.0a14
  ]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "90996fc8d4b5dbdbd9b02e3795fd0d886a360a7e891694319d76a0830f243e4c"
    sha256 cellar: :any, arm64_tahoe:       "b73486404c29ee831a959795099c203fc73472382d834ef7586940f04e7a9dbd"
    sha256 cellar: :any, arm64_sequoia:     "e68577d51e2fa64fd91ef49a0554df97aca13fde14cd69402c45a438cea5e6ba"
    sha256 cellar: :any, arm64_linux:       "29c370451152489bb0a3e9891f6ec5373ba165b73e64ec597ef3f2b7e55da062"
    sha256 cellar: :any, x86_64_linux:      "628ace6eb600f27c680b25b7c24bf202af029ac407cade8dd2834bf9e5403adc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15" => [:build, :test] # for bindings, avoid runtime dependency due to `expat`
  depends_on "openssl@4"

  uses_from_macos "curl"
  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # For `pip`
  allow_network_access! :build

  def install
    # BSD-4-Clause is GPL-incompatible so cannot be linked to GPL readline
    # https://www.gnu.org/licenses/gpl-faq.html#OrigBSD
    # https://src.fedoraproject.org/rpms/afflib/blob/f43/f/afflib.spec#_36-38
    odie "readline cannot be a dependency!" if deps.map(&:name).include?("readline")
    ENV["ac_cv_lib_readline_readline"] = "no" unless OS.mac?

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-fuse",
                          "--disable-python",
                          "--disable-silent-rules",
                          "--enable-s3",
                          *std_configure_args
    system "make", "install"

    # We install Python bindings with pip rather than `./configure --enable-python` to avoid
    # managing Setuptools dependency and modifying Makefile to work around our sysconfig patch.
    # As a side effect, we need to imitate the Makefile and provide paths to headers/libraries.
    ENV.append_to_cflags "-I#{include}"
    ENV.append "LDFLAGS", "-L#{lib}"

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./pyaff"
  end

  test do
    system bin/"affcat", "-v"

    system python3, "-c", "import pyaff"
  end
end

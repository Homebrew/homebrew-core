class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/refs/tags/v3.7.22.tar.gz"
  sha256 "67481fc520ff927bf61aea0bf2d660feb73e24cc329335bebb064f8f12115dcb"
  license all_of: [
    "BSD-4-Clause", # AFFLIB 2.0a14 and before
    :public_domain, # contributions after 2.0a14
  ]
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "b784f415c0153eb93255ebf0b03ede2dbd451f106994b63e0179999bea6fd86d"
    sha256 cellar: :any, arm64_tahoe:       "96657dcee0d8338b2b38786a9f750b71f4baa78b994d28375aeb6e1956616fc2"
    sha256 cellar: :any, arm64_sequoia:     "2b273ea2335bf183fdb60d40625cad40f9b5fb7f2683081d0bb9446d90f202ba"
    sha256 cellar: :any, arm64_linux:       "c54ee296316ec0944d8e452a13ecd60f5c2fd55845fc2d932e89ec0bb3fbb2d8"
    sha256 cellar: :any, x86_64_linux:      "8136600ece77d52143d1401a1d3363a4aa5a0a362e955b29bee680b40c519809"
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

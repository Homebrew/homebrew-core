class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/refs/tags/v3.7.22.tar.gz"
  sha256 "67481fc520ff927bf61aea0bf2d660feb73e24cc329335bebb064f8f12115dcb"
  license all_of: [
    "BSD-4-Clause", # AFFLIB 2.0a14 and before
    :public_domain, # contributions after 2.0a14
  ]

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "16a9e68d5a412285777fd4892d401d98e5cde7d82544ebc532289361ceab286b"
    sha256 cellar: :any,                 arm64_sequoia: "6874090595c0aa86a9d1534f5842aa4e54dbf7f2ee950e9dd20d37bd2a7dd8e1"
    sha256 cellar: :any,                 arm64_sonoma:  "d51a9f8798333e8e76aa4b16646f86fc5a56febd4d18a874dac55c32302efdba"
    sha256 cellar: :any,                 sonoma:        "393511fd03c96d20bcd82e9cbb9280d03b741f5ffaa757cbcde4acfd51231566"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db1e2931a3dfa168f074d44393da3a90c98c700b422af6446bdf7b9b6ced50bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fcf3bc9195cbafae0f9e28d2c4c80dc6700238b25f03e766e89d6867a14afe3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test] # for bindings, avoid runtime dependency due to `expat`
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def python3
    which("python3.14")
  end

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

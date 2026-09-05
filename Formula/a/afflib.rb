class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/refs/tags/v3.7.22.tar.gz"
  sha256 "67481fc520ff927bf61aea0bf2d660feb73e24cc329335bebb064f8f12115dcb"
  license all_of: [
    "BSD-4-Clause", # AFFLIB 2.0a14 and before
    :public_domain, # contributions after 2.0a14
  ]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ef376f647e9bc1cdb381aea75bdacece1e8117105c5b4cca672a24082ac03573"
    sha256 cellar: :any,                 arm64_sequoia: "aae601db1d447ec1744691ecb02bda11390f42e54b513aea01b4c9189d7127cb"
    sha256 cellar: :any,                 arm64_sonoma:  "e59baa723938365a243b4941b42d76f9d1517aa63abbdd7c920632f784a60b1a"
    sha256 cellar: :any,                 sonoma:        "8376b47c12eb57814bfe437f4ec05e4be642fb01b91b64c2a57de8ac526d0f13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "625ddf17091f004214ce3368005b56be681349d836924559e5efffe71fef86b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7521b070c5c4a2e33b5060f015c7f1eb9f74616b97daf3428d7d383e3cba0a42"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test] # for bindings, avoid runtime dependency due to `expat`
  depends_on "openssl@4"

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

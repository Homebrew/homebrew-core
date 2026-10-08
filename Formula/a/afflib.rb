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
    sha256 cellar: :any, arm64_golden_gate: "a1a9c63abded72d914c6619081d539dc450e8ca453855258a06a877e94f0a8a0"
    sha256 cellar: :any, arm64_tahoe:       "e8a43633e8a98a2e10d134960a046f185cadf2ca17b75d141b4a8a294d34c1ec"
    sha256 cellar: :any, arm64_sequoia:     "0a2772ed4ad037c391e4a0db9f957309131fe2076aeb93ac381befd96d6160c5"
    sha256 cellar: :any, arm64_linux:       "c8ed596857ea4714458fdf969ae7963120d01fa5a8dc8cad08ef180e782e09e9"
    sha256 cellar: :any, x86_64_linux:      "ba64302a25269e9d0d70ac12c3e36ca43f851003bc141389bac968120108c1ac"
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

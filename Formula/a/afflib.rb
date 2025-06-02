class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/refs/tags/v3.7.21.tar.gz"
  sha256 "047fce790d69c234dde1d23ad9e1f0cf868ac51b2ad9a76560d01e80f2f1c452"
  license all_of: [
    "BSD-4-Clause", # AFFLIB 2.0a14 and before
    :public_domain, # contributions after 2.0a14
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "415198525cd476abc0821e74c603ed01181276a3dd535ab18040cbe069195581"
    sha256 cellar: :any,                 arm64_sonoma:  "5f03dcc0b3c684a789bf81d700e7ddfe0a14093915c2872634424b55652a1389"
    sha256 cellar: :any,                 arm64_ventura: "6e8bbe1340c8f6b0c0b4e171ce27e0bb58fc7dd4c582dd55ca22cc78f5738599"
    sha256 cellar: :any,                 sonoma:        "dd9226742b7b0c22ec05712fe074202a59af8d6734062ae86080843c8bfa71d1"
    sha256 cellar: :any,                 ventura:       "79daeac53f022c937b8f637b1be92b5b710b9aad7d2072225bacd85516229df9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11e7390f80f0cec23e526eebc6347ec8632dd5c1e0fd7e209c0db7cc330e8acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fad4c5a290b821683ac96da984b2dd64a3c7b09277e58d8a6cf571825069d8c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test] # for bindings, avoid runtime dependency due to `expat`
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  def python3
    which("python3.13")
  end

  def install
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

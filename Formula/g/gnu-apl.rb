class GnuApl < Formula
  desc "GNU implementation of the programming language APL"
  homepage "https://www.gnu.org/software/apl/"
  url "https://ftpmirror.gnu.org/gnu/apl/apl-2.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/apl/apl-2.0.tar.gz"
  sha256 "24bbb744fce47e62837234a053bdeecee51b9ea61c82c79f7cc191bc6a54c0a1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:    "ac779118bbc31c8c7d6a804a4cd19cc34d664fad471408988a67ddef9da6b754"
    sha256 arm64_sequoia:  "82e953cfa3843cb14c56353318d3396ec45c4c000a875a43b01a31d913d626c0"
    sha256 arm64_sonoma:   "f35c1f051bc4aad5808d2197eecf046d6b3a679eadd68e1039b55d7cfc8f9037"
    sha256 arm64_ventura:  "81b929cd47b448e036e52f937498d757daf450b909f201a1d1ea4ed32b643e3d"
    sha256 arm64_monterey: "9658a3ffa6939a5eda6847693000212c3771efe8531d32b54ac04fada499ed26"
    sha256 sonoma:         "f846d1e2a5d45180aab7b9d70b09b682ee305ece2f115beaddadd9d197f872f9"
    sha256 ventura:        "35fb69870f69ed42993e2917d539e80d4bc34013b767f486921d28bff333e3a4"
    sha256 monterey:       "3c142ba8082510e217dba2c772bcc2f19cf3c2f07fb13e93dd3672adea6e229e"
    sha256 arm64_linux:    "43a34760fe0949fcb78d83da6b75d899db63a606869ac53431e86644f76a9898"
    sha256 x86_64_linux:   "6e061bdb88a56797f123cdf50083e1065ba79fa1d3542b30ab1225bd4fd37b10"
  end

  head do
    url "https://svn.savannah.gnu.org/svn/apl/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "pcre2"
  depends_on "readline" # GNU Readline is required, libedit won't work
  depends_on "sqlite"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500

    depends_on "at-spi2-core"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    ENV.append "CXXFLAGS", "-std=c++20"

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"

    integral_py = bin/"integral.py"
    integral_contents = integral_py.read
    integral_py.atomic_write("#!/usr/bin/python3\n#{integral_contents}") unless integral_contents.start_with?("#!")
    chmod 0555, integral_py
  end

  test do
    (testpath/"hello.apl").write <<~EOS
      'Hello world'
      )OFF
    EOS

    pid = spawn bin/"APserver"
    begin
      sleep 4
      assert_match "Hello world", shell_output("#{bin}/apl -s -f hello.apl")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end

class Libsigrokdecode < Formula
  desc "Drivers for logic analyzers and other supported devices"
  homepage "https://sigrok.org/"
  url "https://sigrok.org/download/source/libsigrokdecode/libsigrokdecode-0.5.3.tar.gz"
  sha256 "c50814aa6743cd8c4e88c84a0cdd8889d883c3be122289be90c63d7d67883fc0"
  license "GPL-3.0-or-later"
  head "git://sigrok.org/libsigrokdecode", branch: "master"

  livecheck do
    url "https://sigrok.org/wiki/Downloads"
    regex(/href=.*?libsigrokdecode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "1dd481ffea2211f57b990fb3b2399b92a42e4ebb59e235443c80026b022165e1"
    sha256 arm64_big_sur:  "0ef77c40a057d58ac1c991d69b86eaae9685f3a06a69f83a7905a0f874c20bd2"
    sha256 monterey:       "67d2ea9ddcbc9a4fd79fdb1863e9ed20aa0d60fc563af2fb44a6949cf0918e1c"
    sha256 big_sur:        "e28391425f551996a4690bb30fdad8101f61d13593c2e1c58980ba5dd855f927"
    sha256 catalina:       "9f876cea7ee66ad040de81968869f5d9bbc2193f296aa72a43e7ec5617b708c0"
    sha256 x86_64_linux:   "90aa200a27552e7f3f3fb3b7d56e44519add7573a68842da92a3cecbb7550cc3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "python@3.9"

  def install
    py_version = Formula["python@3.9"].version.major_minor

    inreplace "configure.ac" do |s|
      # Force the build system to pick up the right Python 3
      # library. It'll normally scan for a Python library using a list
      # of major.minor versions which means that it might pick up a
      # version that is different from the one specified in the
      # formula.
      s.sub!(/^(SR_PKG_CHECK\(\[python3\], \[SRD_PKGLIBS\],)\n.*$/, "\\1 [python-#{py_version}-embed])")
    end

    if build.head?
      system "./autogen.sh"
    else
      system "autoreconf", "-fiv"
    end

    mkdir "build" do
      system "../configure", *std_configure_args, "PYTHON3=python#{py_version}"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libsigrokdecode/libsigrokdecode.h>

      int main() {
        if (srd_init(NULL) != SRD_OK) {
           exit(EXIT_FAILURE);
        }
        if (srd_exit() != SRD_OK) {
           exit(EXIT_FAILURE);
        }
        return 0;
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libsigrokdecode").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

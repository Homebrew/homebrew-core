class Libsigrokdecode < Formula
  desc "Drivers for logic analyzers and other supported devices"
  homepage "https://sigrok.org/"
  url "https://sigrok.org/download/source/libsigrokdecode/libsigrokdecode-0.5.3.tar.gz"
  sha256 "c50814aa6743cd8c4e88c84a0cdd8889d883c3be122289be90c63d7d67883fc0"
  license "GPL-3.0-or-later"
  revision 2
  head "git://sigrok.org/libsigrokdecode", branch: "master"

  # The upstream website has gone down due to a server failure and the previous
  # download page is not available, so this checks the directory listing page
  # where the `stable` archive is found until the download page returns.
  livecheck do
    url "https://sigrok.org/download/source/libsigrokdecode/"
    regex(/href=.*?libsigrokdecode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "c9270ad711b3a079cde5eeb3700df0d549ef9ebf1e85ed5f60900d24f4ba8ec8"
    sha256 arm64_tahoe:       "bed30b10a44f20e5f2d96a571068a55b34ea8372746c90f110a9ab2aec8b5f3b"
    sha256 arm64_sequoia:     "8197a495bd8e5d4a2bdb2e3a72bbca215b7d93c694bedd78647dfa37d7024b86"
    sha256 arm64_linux:       "3396cd05fc80c5c4f268fd0e00eb1a99b308baa809e7d06a8ba6783eb19e345b"
    sha256 x86_64_linux:      "33c42fe38e333a44de429acc5a425756523db8c50c579ef4770f18e8f55e9a4b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "python@3.15"

  on_macos do
    depends_on "gettext"
  end

  def install
    py_version = Language::Python.major_minor_version(python3)

    # We should be able to remove this in libsigrokdecode >0.5.3, who will
    # check for a version-independent `python3-embed` pkg-config file, and
    # correctly detect the python3 version from our formula dependencies.
    inreplace "configure.ac",
              "SR_PKG_CHECK([python3], [SRD_PKGLIBS],",
              "SR_PKG_CHECK([python3], [SRD_PKGLIBS], [python-#{py_version}-embed],"

    if build.head?
      system "./autogen.sh"
    else
      system "autoreconf", "--force", "--install", "--verbose"
    end

    mkdir "build" do
      system "../configure", *std_configure_args, "PYTHON3=#{python3}"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    flags = shell_output("#{formula_opt_bin("pkgconf")}/pkgconf --cflags --libs libsigrokdecode").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

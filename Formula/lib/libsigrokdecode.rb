class Libsigrokdecode < Formula
  desc "Drivers for logic analyzers and other supported devices"
  homepage "https://sigrok.org/"
  url "https://sigrok.org/download/source/libsigrokdecode/libsigrokdecode-0.5.3.tar.gz"
  sha256 "c50814aa6743cd8c4e88c84a0cdd8889d883c3be122289be90c63d7d67883fc0"
  license "GPL-3.0-or-later"
  revision 1
  head "git://sigrok.org/libsigrokdecode", branch: "master"

  # The upstream website has gone down due to a server failure and the previous
  # download page is not available, so this checks the directory listing page
  # where the `stable` archive is found until the download page returns.
  livecheck do
    url "https://sigrok.org/download/source/libsigrokdecode/"
    regex(/href=.*?libsigrokdecode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 4
    sha256 arm64_tahoe:   "23396e67a66de629ac081dc782c68f9fcd38617f0b6f9127f2f46dbd245f2d37"
    sha256 arm64_sequoia: "d117a9548cd69c1e115b85c7ef62a277b69aa14af761de1748c3bf1811fdd5b1"
    sha256 arm64_sonoma:  "4d85c0c5d5623c0e3714d75c4e4d4fdf00f4c31b760cc1ce43da3ba47ee06521"
    sha256 sonoma:        "3d88591dccf61eaa1381eabf2b0dcff873d72238cf4268f9e2820a9ad4c2648d"
    sha256 arm64_linux:   "d642fc4f3665d70301ea2195b43926e5bf9deefdee64dab83717b90476c68a6a"
    sha256 x86_64_linux:  "4ff7dc34d6405ca194b26dc6cf68637aa81f8161786d7ceb4dd49d2abe1f7b5e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "python@3.14"

  on_macos do
    depends_on "gettext"
  end

  def install
    # While this doesn't appear much better than hardcoding `3.xy`, this allows
    # `brew audit` to catch mismatches between this line and the dependencies.
    python = "python3.14"
    py_version = Language::Python.major_minor_version(python)

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
      system "../configure", *std_configure_args, "PYTHON3=#{python}"
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
    flags = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libsigrokdecode").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

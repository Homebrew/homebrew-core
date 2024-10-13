class Libsigrokdecode < Formula
  desc "Drivers for logic analyzers and other supported devices"
  homepage "https://sigrok.org/"
  url "https://sigrok.org/download/source/libsigrokdecode/libsigrokdecode-0.5.3.tar.gz"
  sha256 "c50814aa6743cd8c4e88c84a0cdd8889d883c3be122289be90c63d7d67883fc0"
  license "GPL-3.0-or-later"
  revision 1
  head "git://sigrok.org/libsigrokdecode", branch: "master"

  livecheck do
    url "https://sigrok.org/wiki/Downloads"
    regex(/href=.*?libsigrokdecode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_sequoia:  "1426c59e7f3789f4372d38d9ae8b937baedf7c4836ffe50f1eb83a5564d9aac7"
    sha256 arm64_sonoma:   "7c1edc6950ff24f926767a8de0721445d5f3c1ea7a103cc17b9313043f396e5b"
    sha256 arm64_ventura:  "fbf08d6b2fde951731f3dac27737defa3680dae8f865accdb40c554eef0302f5"
    sha256 arm64_monterey: "afbc25b9237db3cbfa5d9fe544b9f6f8e6ddf19e93164f4126da0697e1fce0f2"
    sha256 sonoma:         "599ac7858a52cd88934c3f9e38353c655fd83aa957918eac5da7eb233b731daf"
    sha256 ventura:        "f8e69d8cb58936a43c5d9ede4e6c62a4b5e33337881b5aebe51f3745c0a4863c"
    sha256 monterey:       "979c6bdad107fd9fdd5383fe921e65f2abac06ce1495c455ceb283564e048b21"
    sha256 x86_64_linux:   "7d571869e94632f7db6a2ff8db2a08ad09aab49909b1f89f4aba0e0bb14fdef9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "python@3.12"

  def install
    # While this doesn't appear much better than hardcoding `3.10`, this allows
    # `brew audit` to catch mismatches between this line and the dependencies.
    python = "python3.12"
    py_version = Language::Python.major_minor_version(python)

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
      system "autoreconf", "--force", "--install", "--verbose"
    end

    mkdir "build" do
      system "../configure", *std_configure_args, "PYTHON3=#{python}"
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

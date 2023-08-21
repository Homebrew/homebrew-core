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
    rebuild 1
    sha256 arm64_ventura:  "a29a790153bcfb9e63cf5a1cfa682ca90499167c05f5302775a473e479085a82"
    sha256 arm64_monterey: "c085b5022bde6daaed50ed43e96e8da62b11f578a27b74a854d46c2e585b7021"
    sha256 arm64_big_sur:  "71576cbfd8061aa68b6bfa821732c9bc488e62ea72814e3b3b2e5f3487c2c75f"
    sha256 ventura:        "b3ffb3e8c95e44b9071959acafb624c7b6c2906c4a51c1f399611549c57279d4"
    sha256 monterey:       "08da53c93c00b6a93925bb05c7bab0e960d0d51ece414f9723938875e7776d22"
    sha256 big_sur:        "88d2834ae3acf1c102f0afc6c3bd38d746681ce6aa15c24fb4ff1cf11624be99"
    sha256 x86_64_linux:   "c9bb858f8aebd2c8f86a23732254e7394062ec56e44ac521403cfb0c8a24bdf0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "python@3.11"

  def install
    # While this doesn't appear much better than hardcoding `3.10`, this allows
    # `brew audit` to catch mismatches between this line and the dependencies.
    python = "python3.11"
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
    # Needed since `python@3.11` is keg-only.
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["python@3.11"].opt_lib/"pkgconfig"
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libsigrokdecode").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

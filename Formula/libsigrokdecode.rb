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
    sha256 arm64_monterey: "8e30df89f0601ecaed7f5b75fe0868cb9c1521f59cd4e10c2cdbfee02c9b9efa"
    sha256 arm64_big_sur:  "28538e08ec974291612028bfefef0c460ed22f2ec13f6463c023c09104ee4df7"
    sha256 monterey:       "f8b983f9c2f64d14c0fc3657e91c7356634d65291730dc6e867003cd5ad60a3c"
    sha256 big_sur:        "4d3a56d0cd598fdbe4f290fe86fea4fbf73da6a669565b5e3210efc4ea0e6d52"
    sha256 catalina:       "0b6cdb886b7833d264d2cb9f3c3d0ce840af41b2e447d26adb79f5674bec15c6"
    sha256 x86_64_linux:   "94870e155eccbfb2c4125cf15d5df9dc68f9ef0c84e6b9fff07e0bd978077016"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "python@3.10"

  def install
    # While this doesn't appear much better than hardcoding `3.10`, this allows
    # `brew audit` to catch mismatches between this line and the dependencies.
    python = "python3.10"
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
    # Needed since `python@3.10` is keg-only.
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["python@3.10"].opt_lib/"pkgconfig"
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libsigrokdecode").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

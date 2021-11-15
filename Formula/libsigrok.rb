class Libsigrok < Formula
  desc "Drivers for logic analyzers and other supported devices"
  homepage "https://sigrok.org/"
  # libserialport is LGPL3+
  # fw-fx2lafw is GPL-2.0-or-later and LGPL-2.1-or-later"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  stable do
    url "git://sigrok.org/libsigrok",
        tag:      "libsigrok-0.5.2",
        revision: "a6b07d7e28fe445afccf36922ef7d20e63e54fe6"
    sha256 "4d341f90b6220d3e8cb251dacf726c41165285612248f2c52d15df4590a1ce3c"

    resource "libserialport" do
      url "git://sigrok.org/libserialport",
          tag:      "libserialport-0.1.1",
          revision: "348a6d353af8ac142f68fbf9fe0f4d070448d945"
    end

    resource "fw-fx2lafw" do
      url "git://sigrok.org/sigrok-firmware-fx2lafw",
          tag:      "sigrok-firmware-fx2lafw-0.1.7",
          revision: "b6ec4813b592757e39784b9b370f3b12ae876954"
    end
  end

  livecheck do
    url :stable
    regex(/^libsigrok-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "a1632041336ea122f3b66426e1fb7ec38acb0f5fefa974afe11bce598fd5f271"
    sha256 big_sur:       "85145a60cbb7282c1338d9214d91489ef58a409d6884ec9ed55e854634e2dde4"
    sha256 catalina:      "690126f07d977fe9ae4beb754073405279f35fdcb874b4a10cf7c087a1e9ac01"
    sha256 x86_64_linux:  "255ef573fec2d17e6a693711db00744e0a0440a060b1db430b00fa638b993bc5"
  end

  head do
    url "git://sigrok.org/libsigrok", branch: "master"

    resource "libserialport" do
      url "git://sigrok.org/libserialport", branch: "master"
    end

    resource "fw-fx2lafw" do
      url "git://sigrok.org/sigrok-firmware-fx2lafw", branch: "master"
    end
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "sdcc" => :build
  depends_on "swig" => :build
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "hidapi"
  depends_on "libftdi"
  depends_on "libusb"
  depends_on "libzip"
  depends_on "nettle"
  depends_on "numpy"
  depends_on "pygobject3"
  depends_on "python@3.9"

  resource "fw-fx2lafw" do
    url "https://sigrok.org/download/binary/sigrok-firmware-fx2lafw/sigrok-firmware-fx2lafw-bin-0.1.7.tar.gz"
    sha256 "c876fd075549e7783a6d5bfc8d99a695cfc583ddbcea0217d8e3f9351d1723af"
  end

  def install
    resource("fw-fx2lafw").stage do
      system "./autogen.sh"
      mkdir "build" do
        system "../configure", *std_configure_args
        system "make", "install"
      end
    end

    resource("libserialport").stage do
      system "./autogen.sh"
      mkdir "build" do
        system "../configure", *std_configure_args
        system "make", "install"
      end
    end

    # We need to use the Makefile to generate all of the dependencies
    # for setup.py, so the easiest way to make the Python libraries
    # work is to adjust setup.py's arguments here.
    inreplace "Makefile.am" do |s|
      s.gsub!(/^(setup_py =.*setup\.py .*)/, "\\1 --no-user-cfg")
      s.gsub!(/(\$\(setup_py\) install)/, "\\1 --single-version-externally-managed --record=installed.txt")
    end

    system "./autogen.sh"
    mkdir "build" do
      ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"
      ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
      args = %w[
        --disable-java
        --disable-ruby
      ]
      system "../configure", *std_configure_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libsigrok/libsigrok.h>

      int main() {
        struct sr_context *ctx;
        if (sr_init(&ctx) != SR_OK) {
           exit(EXIT_FAILURE);
        }
        if (sr_exit(ctx) != SR_OK) {
           exit(EXIT_FAILURE);
        }
        return 0;
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libsigrok").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    system Formula["python@3.9"].opt_bin/"python3", "-c", <<~EOS
      import sigrok.core as sr
      sr.Context_create()
    EOS
  end
end

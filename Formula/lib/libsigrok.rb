class Libsigrok < Formula
  desc "Drivers for logic analyzers and other supported devices"
  homepage "https://sigrok.org/"
  # fw-fx2lafw is GPL-2.0-or-later and LGPL-2.1-or-later"
  license all_of: ["GPL-3.0-or-later", "GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 5

  stable do
    url "https://sigrok.org/download/source/libsigrok/libsigrok-0.5.2.tar.gz"
    sha256 "4d341f90b6220d3e8cb251dacf726c41165285612248f2c52d15df4590a1ce3c"

    # build patch to replace `PyEval_CallObject` with `PyObject_CallObject`
    patch do
      url "https://github.com/sigrokproject/libsigrok/commit/5bc8174531df86991ba8aa6d12942923925d9e72.patch?full_index=1"
      sha256 "247bfee9777a39d5dc454a999ce425a061cdc48f4956fdb0cc31ec67a8086ce0"
    end

    resource "fw-fx2lafw" do
      url "https://sigrok.org/download/source/sigrok-firmware-fx2lafw/sigrok-firmware-fx2lafw-0.1.7.tar.gz"
      sha256 "a3f440d6a852a46e2c5d199fc1c8e4dacd006bc04e0d5576298ee55d056ace3b"

      # Backport fixes to build with sdcc>=4.2.3. Remove in the next release of fw-fx2lafw.
      patch do
        url "https://github.com/sigrokproject/sigrok-firmware-fx2lafw/commit/5aab87d358a4585a10ad89277bb88ad139077abd.patch?full_index=1"
        sha256 "15a9ab04d19231aef165d62c669832638c688d33ebd52021100e60e965a5b4e7"
      end
      patch do
        url "https://github.com/sigrokproject/sigrok-firmware-fx2lafw/commit/3e08500d22f87f69941b65cf8b8c1b85f9b41173.patch?full_index=1"
        sha256 "75c4a7770fe8f7d615e3be6c35fa336f8771fbd88145e7ce41afb0d8ad559571"
      end
      patch do
        url "https://github.com/sigrokproject/sigrok-firmware-fx2lafw/commit/96b0b476522c3f93a47ff8f479ec08105ba6a2a5.patch?full_index=1"
        sha256 "a2de37d89144746f6370942faad4c358c6426f8e4e6737f117f05f05d8d44f6a"
      end
    end
  end

  # The upstream website has gone down due to a server failure and the previous
  # download page is not available, so this checks the directory listing page
  # where the `stable` archive is found until the download page returns.
  livecheck do
    url "https://sigrok.org/download/source/libsigrok/"
    regex(/href=.*?libsigrok[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 4
    sha256                               arm64_tahoe:   "6c226511f47960806234805a61c081be4951ac579cb9492c61940f92360b1b81"
    sha256                               arm64_sequoia: "ae00fe2035dcc37cd642d351aae8f1e5670196abe63a5b618fb2e11cea120623"
    sha256                               arm64_sonoma:  "b736c6afd2d3db63696355aa02b613237dacf115b626f384e2a97e9688990ae9"
    sha256                               sonoma:        "9be55acc242d543e4f1d853e1d58df3f9c05840bdb3e959649c9e36a8d0194ea"
    sha256                               arm64_linux:   "e8ee1b325f73075f927dff66d9d02c419273fb98f00084485fbabc6fa05edb1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28e1eeccbe1471973305c0c57cdf01e454623fdee93b47ec0a7567ac10fca17b"
  end

  head do
    url "git://sigrok.org/libsigrok", branch: "master"

    depends_on "nettle"

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
  depends_on "pkgconf" => [:build, :test]
  depends_on "python-setuptools" => :build
  depends_on "sdcc" => :build
  depends_on "swig" => :build

  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "hidapi"
  depends_on "libftdi"
  depends_on "libserialport"
  depends_on "libusb"
  depends_on "libzip"
  depends_on "numpy"
  depends_on "pygobject3"
  depends_on "python@3.14"

  on_macos do
    depends_on "gettext"
    depends_on "libsigc++@2"
  end

  # Fix for swig 4.4 changing the return type of %init
  patch :DATA

  def python3
    "python3.14"
  end

  def install
    resource("fw-fx2lafw").stage do
      system "./autogen.sh" if build.head?

      mkdir "build" do
        system "../configure", *std_configure_args
        system "make", "install"
      end
    end

    # We need to use the Makefile to generate all of the dependencies
    # for setup.py, so the easiest way to make the Python libraries
    # work is to adjust setup.py's arguments here.
    prefix_site_packages = prefix/Language::Python.site_packages(python3)
    inreplace "Makefile.am" do |s|
      s.gsub!(/^(setup_py =.*setup\.py .*)/, "\\1 --no-user-cfg")
      s.gsub!(
        /(\$\(setup_py\) install)/,
        "\\1 --single-version-externally-managed --record=installed.txt --install-lib=#{prefix_site_packages}",
      )
    end

    if build.head?
      system "./autogen.sh"
    else
      system "autoreconf", "--force", "--install", "--verbose"
    end

    mkdir "build" do
      ENV["PYTHON"] = python3
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
    (testpath/"test.c").write <<~C
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
    C
    flags = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libsigrok").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    system python3, "-c", <<~PYTHON
      import sigrok.core as sr
      sr.Context.create()
    PYTHON
  end
end

__END__
diff --git a/bindings/python/sigrok/core/classes.i b/bindings/python/sigrok/core/classes.i
--- a/bindings/python/sigrok/core/classes.i
+++ b/bindings/python/sigrok/core/classes.i
@@ -85,1 +85,1 @@ typedef guint pyg_flags_type;
-        return nullptr;
+        return 0;

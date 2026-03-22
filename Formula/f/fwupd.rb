class Fwupd < Formula
  include Language::Python::Virtualenv

  desc "Firmware update daemon"
  homepage "https://github.com/fwupd/fwupd"
  url "https://github.com/fwupd/fwupd/releases/download/2.1.1/fwupd-2.1.1.tar.xz"
  sha256 "0ae697f1f2011571310cef5d96429d8a5d541f73b0025bd2b622c9c7f4fe05b6"
  license "LGPL-2.1-or-later"
  head "https://github.com/fwupd/fwupd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "78b0a4e435cba73b480495b554ddc03141e8faad8e51610e3173c75220d10bc1"
    sha256 arm64_sequoia: "0c4de2faf2e4d18be5565846ca391d0448e25c137b3607d1e41b83a16bef29de"
    sha256 arm64_sonoma:  "f311aa82bccc6fb683b7abfd0833a0d9ee97a524f680635af4da56f4322d220d"
    sha256 sonoma:        "36b3d2a6996c800b1039827469aa6a6845f2f2ef6268d32732a1b3c2094b0e63"
    sha256 arm64_linux:   "87a4a084eda8deab87794d7d895ff86daad0dce9744b67936d330f40d1c49942"
    sha256 x86_64_linux:  "a31c8b63590dec1fe0abea7b1ba9ddb0b454b201e79023ad4dedf08233ee6461"
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.14" => :build
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "libcbor"
  depends_on "libjcat"
  depends_on "libusb"
  depends_on "libxmlb"
  depends_on "readline"
  depends_on "sqlite"
  depends_on "usb.ids"
  depends_on "xz"

  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  pypi_packages package_name:   "",
                extra_packages: ["jinja2", "markupsafe"]

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  def python3
    "python3.14"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.root/Language::Python.site_packages(python3)

    system "meson", "setup", "build",
                    "-Dbuild=standalone", # this is used as PolicyKit is not available on macOS
                    "-Dpython=#{which(python3)}",
                    "-Dsupported_build=enabled",
                    "-Dplugin_flashrom=disabled",
                    "-Dplugin_modem_manager=disabled",
                    "-Dplugin_uefi_capsule_splash=false",
                    "-Dtests=false",
                    "-Ddocs=disabled",
                    "-Dvendor_ids_dir=#{Formula["usb.ids"].opt_share}/misc/usb.ids",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # check apps like gnome-firmware can link
    (testpath/"test.c").write <<~C
      #include <fwupd.h>
      int main(int argc, char *argv[]) {
        FwupdClient *client = fwupd_client_new();
        g_assert_nonnull(client);
        return 0;
      }
    C

    pkgconf_flags = shell_output("pkgconf --cflags --libs fwupd").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkgconf_flags
    system "./test"

    # this is a lame test, but fwupdtool requires root access to do anything much interesting
    system bin/"fwupdtool", "-h"
  end
end

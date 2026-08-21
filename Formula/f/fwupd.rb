class Fwupd < Formula
  include Language::Python::Virtualenv

  desc "Firmware update daemon"
  homepage "https://github.com/fwupd/fwupd"
  url "https://github.com/fwupd/fwupd/releases/download/2.1.7/fwupd-2.1.7.tar.xz"
  sha256 "472e9426f7a1b18fa9d199666c15482d4ee51ea35e916ca53bb3ca25919edb10"
  license "LGPL-2.1-or-later"
  head "https://github.com/fwupd/fwupd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "2c13bbb68ba70e822eef84b8aa6e14de77cef14b300e339e36afaefa2045c3cc"
    sha256 arm64_sequoia: "a734cb1f1e20c4ba1b1aad778f2f433b4c050a4e0bc6b6d63e0ea66296f00900"
    sha256 arm64_sonoma:  "152453522babdd351986ef97f23a416e05c82f40b6fe26ceea1d7762ebccaf13"
    sha256 sonoma:        "3fef4c9f1a7cdbc2adb5d4d3dc9ce8dce99bf1606ddbe083bee8f9fa3b409db9"
    sha256 arm64_linux:   "5562a3a0da5f0f416a7343af282609493650de5d9ff6f68cd7dd5ce85e9f8c4b"
    sha256 x86_64_linux:  "1173b922171ee90211fa684d1ee6eb66229036fb08369caed07fa83f2d6ed159"
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

  def install
    python3 = "python3.14"
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    args = [
      "-Dbuild=standalone", # this is used as PolicyKit is not available on macOS
      "-Dpython=#{which(python3)}",
      "-Dsupported_build=enabled",
      "-Dplugin_modem_manager=disabled",
      "-Dplugin_uefi_capsule_splash=false",
      "-Dtests=false",
      "-Ddocs=disabled",
      "-Dvendor_ids_dir=#{Formula["usb.ids"].opt_share}/misc/usb.ids",
    ]
    # avoid installing into systemd's read-only Cellar
    args << "-Dsystemd=disabled" if OS.linux?

    system "meson", "setup", "build", *args, *std_meson_args
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

class Fwupd < Formula
  include Language::Python::Virtualenv

  desc "Firmware update daemon"
  homepage "https://github.com/fwupd/fwupd"
  url "https://github.com/fwupd/fwupd/releases/download/2.1.8/fwupd-2.1.8.tar.xz"
  sha256 "8724305a52621ab6586de3290f6a78edb8393a4aa4bcb6c63f9228ae5e00acf8"
  license "LGPL-2.1-or-later"
  head "https://github.com/fwupd/fwupd.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "b2e931884b4844bf2f616a60be7fc73a07fc2a0cb6867204898423278c4389ba"
    sha256 arm64_tahoe:       "d67ebfacc236c51c0cbbdedc288fa94425399327e73bb3f9afa860665c1824e3"
    sha256 arm64_sequoia:     "2dff8a6939d04229fc7ec7886c9e9be8e36b01a4220ac109ee932b396ad80c79"
    sha256 arm64_linux:       "f56ea33713b3e07dcb6b378999d10a823c6fefc9fdef1f946621ee27fcaf1d11"
    sha256 x86_64_linux:      "dfd4ad174090e247f02d356de19f68702514c4bb17b9ab0ee4832bc8dcc09893"
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.15" => :build
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
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    args = [
      "-Dbuild=standalone", # this is used as PolicyKit is not available on macOS
      "-Dpython=#{python3}",
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

class Fwupd < Formula
  include Language::Python::Virtualenv

  desc "Firmware update daemon"
  homepage "https://github.com/fwupd/fwupd"
  url "https://github.com/fwupd/fwupd/releases/download/2.1.10/fwupd-2.1.10.tar.xz"
  sha256 "cb23ab505cabaf616dacfc199f710f883329e8782ca3aa67548bdb7181d62fab"
  license "LGPL-2.1-or-later"
  head "https://github.com/fwupd/fwupd.git", branch: "main"

  bottle do
    manifest_sha256 "57c222b4cfb868f2397d73cf49c5198328704bcd358a0813e79507d3019d8b6e"
    sha256 arm64_golden_gate: "e4fd71b1c53999fdeb720ecc39a6c6d06da841691e41f09e06b9e8a6616c77bc"
    sha256 arm64_tahoe:       "470ab3b92d3c0c6c6b8ff277b46822bcae2c84ce714a6c4176c253d2dd43656f"
    sha256 arm64_sequoia:     "8a99217b06ab51d145bcb532bfeb3374b67d2f519600d87f9f461991f569db2d"
    sha256 arm64_linux:       "2184942e0f6903c60ebfd088c6802b3bd09e6b76c204a9c23bc37149c64506ca"
    sha256 x86_64_linux:      "603caafbe0b2addf42a46d63cb5a8156fb43f0ae3ed9e9f94b7180c3459e6e17"
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
      "-Dopenssl=disabled", # GnuTLS already provides crypto; avoid linking an indirect `openssl@4`
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

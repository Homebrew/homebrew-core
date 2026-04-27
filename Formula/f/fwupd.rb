class Fwupd < Formula
  include Language::Python::Virtualenv

  desc "Firmware update daemon"
  homepage "https://github.com/fwupd/fwupd"
  url "https://github.com/fwupd/fwupd/releases/download/2.1.2/fwupd-2.1.2.tar.xz"
  sha256 "7d8d0762aa4095e8e7211a91550ab5c4db5e4fb4cad48087da522f580a4cc9d9"
  license "LGPL-2.1-or-later"
  head "https://github.com/fwupd/fwupd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "a35739a643319da1be04abdc86d4acac25e47677d890a6b58421c64bdb0d001d"
    sha256 arm64_sequoia: "ec1ea32559a32ca505b4c771255bcc33fb898a28baa0401755f915cea3ce72c0"
    sha256 arm64_sonoma:  "1167c8fa77032b5be065cd074ca633976f8815700a4bedd07def8981674265b6"
    sha256 sonoma:        "6a98f1b4f006d04e80ffc23b7f9438af2e9a133627b34194e9c1d8c455a08cad"
    sha256 arm64_linux:   "9cd874b2b411b350be557be090d7937850effebe3d2b8b760a4c3870784d6aeb"
    sha256 x86_64_linux:  "72b8ef791edc2077cb1b47d7b39632aa4761b4a539b86d9670cc4595f2c37e6b"
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

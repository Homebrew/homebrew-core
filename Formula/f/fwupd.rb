class Fwupd < Formula
  include Language::Python::Virtualenv

  desc "Firmware update daemon"
  homepage "https://github.com/fwupd/fwupd"
  url "https://github.com/fwupd/fwupd/releases/download/2.1.5/fwupd-2.1.5.tar.xz"
  sha256 "9bde8d85ceb4ea30c92272cfe17941d8cd25ab469402864bc6981585d7eacc07"
  license "LGPL-2.1-or-later"
  head "https://github.com/fwupd/fwupd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "22b19fc94b22a8301651e006744d24be16b840a1a17afb97a96b7c89fc7d70b3"
    sha256 arm64_sequoia: "d324179c0ff617be09a88d4ba7fc8fb89449a91dedd234c162a08500a8bc9f46"
    sha256 arm64_sonoma:  "99a2926bd803ea79fed54d5e388a4623ea82bd5a3d46ff355d3f6eda32a9629f"
    sha256 sonoma:        "9ceeead750b48b2318382223bdba915b2dd66837673eb889f1329b8196350bb3"
    sha256 arm64_linux:   "879672ec4e8cb8d86c65522c84e87523dfe6d9bc15a43d7911f8080839725b87"
    sha256 x86_64_linux:  "532502ebdf1b6643a8b661478748b380f9f3334679cfb76a82b5702c0d4536ce"
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

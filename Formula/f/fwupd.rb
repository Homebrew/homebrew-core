class Fwupd < Formula
  include Language::Python::Virtualenv

  desc "Firmware update daemon"
  homepage "https://github.com/fwupd/fwupd"
  url "https://github.com/fwupd/fwupd/releases/download/2.0.1/fwupd-2.0.1.tar.xz"
  sha256 "04226d0c689a56cc51de017e736f18f1f5e951b9a7c1b18e3281eb923c435891"
  license "LGPL-2.1-or-later"
  head "https://github.com/fwupd/fwupd.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "659c89da91376502a404700b63afd3591b222c0c342de99611d1dc5afcb1fdc6"
    sha256 arm64_sonoma:  "ca396b71e06d3a1216be63544f462a83c539ba4ee5745999d4f8fe79a0659f6c"
    sha256 arm64_ventura: "73ea0b5e952b5f14460a48c0367f20e7520fd0758921864b4b440d0328b73fdf"
    sha256 sonoma:        "51540021d772f6fcc2039086c39bcc6499665fa678ffb32def303111d25955e4"
    sha256 ventura:       "b08e95f65d87d070691efb4c212c97c5d95290358fea72031a9e93c8e3cef5a0"
    sha256 x86_64_linux:  "da0d2f3c1f1bce9c2240e4fbb0458242f7722aa05a865b35a77142d86e148e62"
  end

  depends_on "gettext" => :build
  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.12" => :build
  depends_on "vala" => :build

  depends_on "gcab"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libcbor"
  depends_on "libjcat"
  depends_on "libusb"
  depends_on "libxmlb"
  depends_on "protobuf-c"
  depends_on "sqlite"
  depends_on "usb.ids"
  depends_on "xz"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b4/d2/38ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8f/markupsafe-3.0.1.tar.gz"
    sha256 "3e683ee4f5d0fa2dde4db77ed8dd8a876686e3fc417655c2ece9a90576905344"
  end

  def python3
    "python3.12"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", buildpath/"venv"/Language::Python.site_packages(python3)

    system "meson", "setup", "build",
                    "-Dbuild=standalone", # this is used as PolicyKit is not available on macOS
                    "-Dlibarchive=enabled", # fail if missing
                    "-Dpython=#{which(python3)}",
                    "-Dsupported_build=enabled",
                    "-Dplugin_flashrom=disabled",
                    "-Dplugin_gpio=disabled",
                    "-Dplugin_modem_manager=disabled",
                    "-Dplugin_msr=disabled",
                    "-Dplugin_tpm=disabled",
                    "-Dplugin_uefi_capsule=disabled",
                    "-Dplugin_uefi_pk=disabled",
                    # these two are needed for https://github.com/fwupd/fwupd/pull/6147
                    "-Dplugin_logitech_scribe=disabled",
                    "-Dplugin_logitech_tap=disabled",
                    "-Dvendor_ids_dir=#{Formula["usb.ids"].opt_share}/misc/usb.ids",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # check apps like gnome-firmware can link
    (testpath/"test.c").write <<~EOS
      #include <fwupd.h>
      int main(int argc, char *argv[]) {
        FwupdClient *client = fwupd_client_new();
        g_assert_nonnull(client);
        return 0;
      }
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs fwupd").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    system "./test"

    # this is a lame test, but fwupdtool requires root access to do anything much interesting
    system bin/"fwupdtool", "-h"
  end
end

class Fwupd < Formula
  include Language::Python::Virtualenv

  desc "Firmware update daemon"
  homepage "https://github.com/fwupd/fwupd"
  url "https://github.com/fwupd/fwupd/releases/download/2.0.18/fwupd-2.0.18.tar.xz"
  sha256 "c6d9e5fcbc63354344016dd398fc6b6050747b35636551df022f52ffe3957382"
  license "LGPL-2.1-or-later"
  head "https://github.com/fwupd/fwupd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "50324cc49d39ff3120d7adcaf16920d92615c3cec3d2e293aeb26cf077b48280"
    sha256 arm64_sequoia: "d091935e988857b20739e792aea1b8418b901b4c2d0cac479ec2e4208cd6672a"
    sha256 arm64_sonoma:  "0c8340fc4b773ea38511d695216a7aa2114d9056994912bf68a26f31176a9e27"
    sha256 sonoma:        "4859eaf1e8c3662c8896c266151d598b6e401866304d7c2a510c0a3cc4031850"
    sha256 arm64_linux:   "a9805812fb47752dd44975fc305c568377d5aa2e2f60752e3e7b6219f0e9f74b"
    sha256 x86_64_linux:  "2d2278b9855180448c67274e5f60b423a0b670e68f026d0c795f760149d08ddb"
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
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libcbor"
  depends_on "libjcat"
  depends_on "libusb"
  depends_on "libxmlb"
  depends_on "protobuf-c"
  depends_on "readline"
  depends_on "sqlite"
  depends_on "usb.ids"
  depends_on "xz"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "util-linux"
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
    ENV.prepend_path "PYTHONPATH", buildpath/"venv"/Language::Python.site_packages(python3)

    system "meson", "setup", "build",
                    "-Dbuild=standalone", # this is used as PolicyKit is not available on macOS
                    "-Dlibarchive=enabled", # fail if missing
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

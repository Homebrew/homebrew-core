class OsinfoDbTools < Formula
  desc "Tools for managing the libosinfo database files"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/osinfo-db-tools-1.10.0.tar.xz"
  sha256 "802cdd53b416706ea5844f046ddcfb658c1b4906b9f940c79ac7abc50981ca68"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?osinfo-db-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "4c36d9142080cc03a5bbb5a7ade982081d79719508a67ba42d169c84ee94d2f7"
    sha256 arm64_monterey: "1d1c7ce896178ca36d6e80d74c4ee079ccef9d33aa23b3497507ae10a0e639ba"
    sha256 arm64_big_sur:  "82486837eb8ac3f291f0c19417fb3c039a6f8dc964a53cdbefd38a3ace4f4082"
    sha256 ventura:        "6f5e709bed6a434e739b0dbb045acd2ad934d67cf43ac6ca266d5b36cc43ee51"
    sha256 monterey:       "5fd3aecf2c0b5d73a53ca7f040492b18488fcae29e95a87f472e5b7748b4656d"
    sha256 big_sur:        "b8f2bb99ccdf6e52e3b9210047975945e145b710066a870562a16ab1d1e8fa1d"
    sha256 catalina:       "b15b9a51705d8bdcfd115f9e43fd9129a84a7004efc3229e19d3e0286432914d"
    sha256 x86_64_linux:   "ff2927f346097164c57287e06974a74455e79d9f0ef62f438ff0e4ffadfaa266"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libsoup"

  uses_from_macos "pod2man" => :build
  uses_from_macos "libxml2"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "install", "-v"
    end
  end

  def post_install
    share.install_symlink HOMEBREW_PREFIX/"share/osinfo"
  end

  test do
    assert_equal "#{share}/osinfo", shell_output("#{bin}/osinfo-db-path --system").strip
  end
end

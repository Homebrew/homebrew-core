class OsinfoDbTools < Formula
  desc "Tools for managing the libosinfo database files"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/osinfo-db-tools-1.11.0.tar.xz"
  sha256 "8ba6d31bb5ef07056e38879e070671afbcfec0eb41a87f9950450bbb831b0a1d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?osinfo-db-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "ea20a96eb2678de7f59003461687d8c5ffc9678c9445ac8eb7047853b2ca9208"
    sha256 arm64_sonoma:   "aa8cecff697e8148cad3a8b377bc84a68adac962bdfde26299ceb5ee5dcfde8f"
    sha256 arm64_ventura:  "f94e052981d9b9bb4cbf8c0abae53d27719a50dc832fbe9844d644deed52ea91"
    sha256 arm64_monterey: "da657c016ad70ae0dd4a7dce65dc6074953c808beb91d1f6af6a2236899b8429"
    sha256 sonoma:         "4c8286a70b9fed19db3f12f2585bc66a55b2d4d73b7c17eb04b83cfd9f0f047e"
    sha256 ventura:        "b9da5f579dfc529948bad172a91f5cc3a98659bd5df4fe9ba5b087384014e901"
    sha256 monterey:       "f69babd6cbfff01b88f40070d9cb42598a99589d7cef78f749dee883dfe0ba51"
    sha256 x86_64_linux:   "43188efa0b9507f0f0e225bf87481ae940895be408baeeaa715a26b98e473330"
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
    system "meson", "setup", "build", *std_meson_args
    system "meson", "install", "-C", "build"
  end

  def post_install
    share.install_symlink HOMEBREW_PREFIX/"share/osinfo"
  end

  test do
    assert_equal "#{share}/osinfo", shell_output("#{bin}/osinfo-db-path --system").strip
  end
end

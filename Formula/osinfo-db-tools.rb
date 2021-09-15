class OsinfoDbTools < Formula
  desc "Tools for managing the libosinfo database files"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/osinfo-db-tools-1.9.0.tar.xz"
  sha256 "255f1c878bacec70c3020ff5a9cb0f6bd861ca0009f24608df5ef6f62d5243c0"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?osinfo-db-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "800f45e86f13d9b276e419c7df616033ede3dd8f4a3956c698fe0f09be436035"
    sha256 big_sur:       "460a75b81da6d76332f29596cecc9bcf543262e8d5848c7fb1bf627b5c5645ad"
    sha256 catalina:      "8a572a5e4559404c4ee8b293d934286a155debc374c6e9acbb19decf480e7d5e"
    sha256 mojave:        "784931937986f8132ca5f742ce7d966fe08eb11742d1bbf48d5253ecbcff3bfb"
    sha256 x86_64_linux:  "95a2338adb2f05354a14fcf5bec97cd5a0bdb03e5f1d3b1f9664e829d9b911bf"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libsoup"
  depends_on "python@3.9"

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

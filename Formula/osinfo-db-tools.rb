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
    rebuild 1
    sha256 arm64_monterey: "8be0254023c9cc2b6020ceb0cfbe0ded607b618f466d59e9877a38e03f658cb8"
    sha256 arm64_big_sur:  "16e25d6c6f291ee858eb7d6bce60c75470269317a02c5e94a6b67a7378020177"
    sha256 monterey:       "a10baa04d411298ffa19ff71899990e29ce7ce4f752a86eb19b97a640e9c6078"
    sha256 big_sur:        "dc0ff11e571cdceb53a3d581d5259b638726181bb4413ae94106d8754d29de5c"
    sha256 catalina:       "5f4ba5dfa744e36530bb021d094febe34d788badea61cc8280a7371fab4847c1"
    sha256 x86_64_linux:   "f3673bced7bf3ed645d14930dbeddf2c298884dc2110487b253d68ba9364b784"
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

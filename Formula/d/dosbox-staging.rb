class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  license "GPL-2.0-or-later"
  head "https://github.com/dosbox-staging/dosbox-staging.git", branch: "main"

  stable do
    url "https://github.com/dosbox-staging/dosbox-staging/archive/refs/tags/v0.81.0.tar.gz"
    sha256 "211cbd2fb781bee1e92963f57e8111e22bcaf17a3a6dc11189982a0eea311e9b"

    # Backport fix to bypass SDL wraps on macOS
    patch do
      url "https://github.com/dosbox-staging/dosbox-staging/commit/9f0fc1dc762010e5f7471d01c504d817a066cae3.patch?full_index=1"
      sha256 "20b009216d877138802c698fc9aa89ea1c2becc3c13c06bdcf388ffe7a63bef2"
    end
  end

  # New releases of dosbox-staging are indicated by a GitHub release (and
  # an announcement on the homepage), not just a new version tag.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "5efb7dd68cacf7b99cd6c7806e91cd72a933839880bfe726fdb9ec9312f99f45"
    sha256 arm64_ventura:  "40b37eb2976c6ceb7b5620550e2bac211282423427aa0e87bdd0cae543ac44d8"
    sha256 arm64_monterey: "667fbbba6c06cea8245fff7686654d0f3c1c687b4cdcadf79bcb3d94b06f5e33"
    sha256 sonoma:         "9a9689f7fac4c2fdfc521491d18c9bad32127302d3b751b9b28c25af06c805c4"
    sha256 ventura:        "2d605146c48edd4b0bb9bc61080c0ab3852b4fe12644a856cd60d3a6b91db68f"
    sha256 monterey:       "9ee63a8cdd9f459c829d567f519192942cd15856e7cfb2b69eaf5b9ac869b2af"
    sha256 x86_64_linux:   "5f58569ee83bcd0748f2cfad9d2910300648ad624a84a9cb07ae6e097a1d8bf4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "glib"
  depends_on "iir1"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "mt32emu"
  depends_on "opusfile"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_net"
  depends_on "speexdsp"
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  fails_with gcc: "5"

  def install
    (buildpath/"subprojects").rmtree # Ensure we don't use vendored dependencies
    args = %w[-Ddefault_library=shared -Db_lto=true -Dtracy=false]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    mv bin/"dosbox", bin/"dosbox-staging"
    mv man1/"dosbox.1", man1/"dosbox-staging.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dosbox-staging -version")
    config_path = OS.mac? ? "Library/Preferences/DOSBox" : ".config/dosbox"
    mkdir testpath/config_path
    touch testpath/config_path/"dosbox-staging.conf"
    output = shell_output("#{bin}/dosbox-staging -printconf")
    assert_equal testpath/config_path/"dosbox-staging.conf", Pathname(output.chomp)
  end
end

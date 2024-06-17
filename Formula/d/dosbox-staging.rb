class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  license "GPL-2.0-or-later"
  head "https://github.com/dosbox-staging/dosbox-staging.git", branch: "main"

  stable do
    url "https://github.com/dosbox-staging/dosbox-staging/archive/refs/tags/v0.81.1.tar.gz"
    sha256 "2b389fdc338454f916240aab5a2ae5560d1dd9808d63c70f34ec9a91e60b535a"

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
    sha256 arm64_sonoma:   "c0acb77ffeec1998eaf05f50fd123f7c5d60cd0eb3650d4b267202a9eed6520a"
    sha256 arm64_ventura:  "8dfd66a126fdf5377b5facf51526bcc1ba3f658c76cad10ad74bfc05d7618719"
    sha256 arm64_monterey: "9ce6593351bc70da42abee12ff5ed96f59ce15b37157127c0ac17500ef805236"
    sha256 sonoma:         "4ce3401dec1900d9db2dd6fc9327d99b9269453e72697468106f26aeb76211fe"
    sha256 ventura:        "40fbcc2a17cbe0a49f52df32206643c25bac07af97e4ba2ace2a3dde609d9f00"
    sha256 monterey:       "956f3c50523268e900a1dbafc938095b0d886a8aa0ba951611388f0847caeafc"
    sha256 x86_64_linux:   "557f821e2cca2f17ff524aa08e07ebba24ca141603588e32eff6771addcea278"
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

class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.29.0.tar.xz"
  sha256 "da3fbcf02877f9be0f028bfa5d1cb59e953a4049b90fe7e39388a3386d9f362e"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://mednafen.github.io/releases/"
    regex(/href=.*?mednafen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "64283880545351f69af0c0256e96a8c03ce26a9f21c962ec50757cefdadb50c0"
    sha256 arm64_big_sur:  "51c237c994ce03894cda2cf49e84ee58c76344a3f7b474d10a18b7a927c0c0eb"
    sha256 monterey:       "73fdf0c65754598ea47914e993825eeda57bb7170d7f53cc64a9400a051ed48c"
    sha256 big_sur:        "998091202b281789570c4e2225858320789473227a5b4bdd2201b4b7414f65b6"
    sha256 catalina:       "8c5675abeb5a41e3585335b1542bf285aceaf12e49d25379ef522ee27d245244"
    sha256 x86_64_linux:   "c811b17ac96212e0b49acc386e49a61948cf77011c57530d661150a1ef8d60c2"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libsndfile"
  depends_on macos: :sierra # needs clock_gettime
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--enable-ss"
    system "make", "install"
  end

  test do
    # Test fails on headless CI: Could not initialize SDL: No available video device
    on_linux do
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    cmd = "#{bin}/mednafen | head -n1 | grep -o '[0-9].*'"
    assert_equal version.to_s, shell_output(cmd).chomp
  end
end

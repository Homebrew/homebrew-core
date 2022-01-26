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
    sha256 arm64_monterey: "38b6257a9ff7c5200d09b518d7085bee6a6fc293e1fd2d59f6a9a6685473e291"
    sha256 arm64_big_sur:  "9b0532261a2b51bb52fdb108094589e000beba6605a04d16fc9959e3faeb2bb7"
    sha256 monterey:       "8d23dff00bab779a86b30c9f97420500e16b3e77567e3971918b5cb6e6e3b0e6"
    sha256 big_sur:        "a3850277082fa95903be57fb69ce907f44d4560ae96a977cf32957f4ddc2790a"
    sha256 catalina:       "a1e8abd3e99532bac5655c40e7d1f1cdb5992f493c736d3662f268c2b3d203a7"
    sha256 x86_64_linux:   "dbd52fbecc93a6fc71cc602ecceca18d0073ba4e1bc7aaf01c051a31ae2664b8"
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

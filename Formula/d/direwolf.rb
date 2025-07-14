class Direwolf < Formula
  desc "Software \"soundcard\" AX.25 packet modem/TNC and APRS encoder/decoder"
  homepage "https://github.com/wb2osz/direwolf"
  license all_of: [
    "GPL-2.0-or-later",
    "ISC", # external/misc/{strlcpy.c,strlcat.c} (Linux)
    :cannot_represent, # external/geotranz, see https://github.com/externpro/geotranz/blob/v2.4.2/readme.txt
  ]
  revision 1
  head "https://github.com/wb2osz/direwolf.git", branch: "master"

  stable do
    url "https://github.com/wb2osz/direwolf/archive/refs/tags/1.7.tar.gz"
    sha256 "6301f6a43e5db9ef754765875592a58933f6b78585e9272afc850acf7c5914be"

    # cmake 4 build patch
    patch do
      url "https://github.com/wb2osz/direwolf/commit/c499496bbc237d0efdcacec5786607f5e17c1c7e.patch?full_index=1"
      sha256 "3b5e2aeecf89284f1684b3e83f4de1bb80dc3bdd5b6ed626856be640718dc8a6"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_sequoia: "f99bcf9fef1cc83130d68c43ae4da0bb86cf3020c53898272c9f3dc3fe1a69b6"
    sha256                               arm64_sonoma:  "d99b828167a2e694d76319a97c1a5806be165f0005849fad1f3c2ed31b8b3486"
    sha256                               arm64_ventura: "32e606d1d65f94fb27a348abf01abadd78c74601c89c47d4ad84bc957fe0c071"
    sha256                               sonoma:        "f34cd15417a27425220ab4f6624f6c90844eb7ac5c15785cccb9122a49537f9e"
    sha256                               ventura:       "185a41a84b513d3bbc9427a55675abdcbdde62b0dca9b736f9016f135f6a5268"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29394877b827bdec83e7082dd20c31ff3481bccbbdb98f77c243b90788c60ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89c355af2b949f2b14372ef9b9935a0de9aca700660987313d52f30887e51a8d"
  end

  depends_on "cmake" => :build
  depends_on "gpsd"
  depends_on "hamlib"

  on_macos do
    depends_on "portaudio"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "systemd"
  end

  def install
    inreplace "src/decode_aprs.c", "/opt/local/share", share
    inreplace "src/symbols.c", "/opt/local/share", share
    inreplace "conf/CMakeLists.txt", " /etc/udev/rules.d", " #{lib}/udev/rules.d"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "--build", "build", "--target", "install-conf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/direwolf -u")

    touch testpath/"direwolf.conf"
    assert_match "Pointless to continue without audio device.", shell_output("#{bin}/direwolf brew", 1)
  end
end

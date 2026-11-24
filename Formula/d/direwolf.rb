class Direwolf < Formula
  desc "Software \"soundcard\" AX.25 packet modem/TNC and APRS encoder/decoder"
  homepage "https://github.com/wb2osz/direwolf"
  url "https://github.com/wb2osz/direwolf/archive/refs/tags/1.8.1.tar.gz"
  sha256 "89d5f7992ae1e74d8cf26ec6479dde74d1f480bde950043756e875a689d065d7"
  license all_of: [
    "GPL-2.0-or-later",
    "ISC", # external/misc/{strlcpy.c,strlcat.c} (Linux)
    :cannot_represent, # external/geotranz, see https://github.com/externpro/geotranz/blob/v2.4.2/readme.txt
  ]
  revision 2
  head "https://github.com/wb2osz/direwolf.git", branch: "master"

  bottle do
    manifest_sha256 "a7b8b74b4ba6ee2b2355a3315747ed44501a0418f66cffe88246859061df5f6f"
    sha256               arm64_golden_gate: "d50933112843f2cc7e41a81fe7a35fabbe146e43ef22f80087bf03584c2c0879"
    sha256               arm64_tahoe:       "19bcd00726f8fa7e2862637a1095319ba0c8ada49db55c19177ebfec2bad67e9"
    sha256               arm64_sequoia:     "2b8c34459e5a7cf7e9c43247d4ec3bc7c9e245a173211c8a496fa4915f5d07cf"
    sha256 cellar: :any, arm64_linux:       "4f685b4ddd43729598fe56bda6345cab22042115189a567d462e98ad95a075cd"
    sha256 cellar: :any, x86_64_linux:      "3cba10e3f2fdbc930965851af4a4f018720209438613a0e1228c728e5c957cfe"
  end

  depends_on "cmake" => :build
  depends_on "gpsd"
  depends_on "hamlib"

  on_macos do
    depends_on "hidapi"
    depends_on "portaudio"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "systemd"
  end

  deny_network_access!

  def install
    inreplace "src/symbols.c", "/opt/local/share", share
    inreplace "conf/CMakeLists.txt", " /usr/lib/udev/rules.d", " #{lib}/udev/rules.d"

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

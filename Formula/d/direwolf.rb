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
  revision 1
  head "https://github.com/wb2osz/direwolf.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "63d881db26ffbc81c6e5cc7d3d6dfcf8c0ee22471315b629a87369e86a6a8ebc"
    sha256                               arm64_sequoia: "3d153fb2f4257bba35a2bdfce4fbbff1f95bb0ae4acc07c9196e32e85e8f40b5"
    sha256                               arm64_sonoma:  "369e5f8c733457ed38ec2efd545dcc3ebe205c3c847a70dd97cab2f827356eee"
    sha256                               sonoma:        "7098d87113aedd2175eae8784c592553d190b4d01fd5c9fb056abad24a706ce3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29d05c5606f17ab0aa22d6819b187a7dccbb9c017d2438116b5fc3670e855ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de9468972aaafbd3f665c3ef710c1bb03a336bba0f6485ab652bf1154fbda2f8"
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

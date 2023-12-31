class Direwolf < Formula
  desc "Software \"soundcard\" AX.25 packet modem/TNC and APRS encoder/decoder"
  homepage "https://github.com/wb2osz/direwolf"
  url "https://github.com/wb2osz/direwolf/archive/refs/tags/1.7.tar.gz"
  sha256 "6301f6a43e5db9ef754765875592a58933f6b78585e9272afc850acf7c5914be"
  license "GPL-2.0-only"
  head "https://github.com/wb2osz/direwolf.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "f15cf78ea350bac7d0daf8663e54242eed663f577400de7630f8225c4e08e340"
    sha256 arm64_ventura:  "494d3a0854c7d919fa8446915bec34806b387c138fd23210c05ab3677c701faf"
    sha256 arm64_monterey: "1c437d0c62b29032faf6eb115caef44b62bc7ef7525d5a137c09eec5015a0f49"
    sha256 sonoma:         "5ad4a23ede0053b7c587b99514c48982378ad7f5e4ae4871e8b8eea6dccb6249"
    sha256 ventura:        "e3064f51ee693453adc1e25a4dc7e7f1617f51d070dc209c847a7459968de0dc"
    sha256 monterey:       "16947ff3e289c953ddb75acb44215ab7f74a5128a20464cfb7f6332b4438f25d"
  end

  depends_on "cmake" => :build
  depends_on "gpsd"
  depends_on "hamlib"
  # Further investigation and work on this
  # formulae is needed to support linux builds. The upstream project
  # provides their own mechanism for linux distribution. Brew is most
  # valuable on macOS, where there is no other suitable package manager,
  # so for now, restrict this formulae to macOS.
  depends_on :macos
  depends_on "portaudio"

  def install
    inreplace "src/decode_aprs.c", "/opt/local/share", share
    inreplace "src/symbols.c", "/opt/local/share", share

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

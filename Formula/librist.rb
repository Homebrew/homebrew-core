class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.7/librist-v0.2.7.tar.gz"
  sha256 "7e2507fdef7b57c87b461d0f2515771b70699a02c8675b51785a73400b3c53a1"
  license "BSD-2-Clause"
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4d72554a101bdc2828090eb8403226f041226b2a19e73ac22f6579bb8980b20c"
    sha256 cellar: :any,                 arm64_big_sur:  "417402199b57d04ad74c097e649d72fbb18573c32621af8b31ad18a97117ddf2"
    sha256 cellar: :any,                 monterey:       "00d5af03d5ade1b78e2b9ffe5ddde2a47219d3aba5bb86770b3f4c5a9d4718f3"
    sha256 cellar: :any,                 big_sur:        "74f30c477bd07b734fe287d0a08520d66db9a21c4800197b2bfd282e8089c517"
    sha256 cellar: :any,                 catalina:       "6433c18aeeffd921e6d068db2e634ee5c0b3daa4244e2bb0112271a1ba1906de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c4031495d0ab4d7a8ad966a9f87d07059add7e7f02fe7eca66abd312fcca1ed"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cjson"
  depends_on "cmocka"
  depends_on "mbedtls"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    system "meson", *std_meson_args, "build", ".", "--default-library", "both"
    system "ninja", "install", "-C", "build"
  end

  test do
    assert_match "Starting ristsender", shell_output("#{bin}/ristsender 2>&1", 1)
  end
end

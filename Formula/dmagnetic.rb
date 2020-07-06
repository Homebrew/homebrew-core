class Dmagnetic < Formula
  desc "Magnetic Scrolls Interpreter"
  homepage "https://www.dettus.net/dMagnetic/"
  url "https://www.dettus.net/dMagnetic/dMagnetic_0.23.tar.bz2"
  sha256 "1e555b6a6ef5b3a54d2fe25ac83fbd100e3df6342a95e88354a2528ceaa8ff0f"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed6fcd7344d6b54b8275ad3e0c1470e552a81b2e88aa2b4ce97ee43a96c01c01" => :catalina
    sha256 "4a7feaa83cdf7a3a4929905125137179c4c9c7cf4076eeae3ea2385461a727d5" => :mojave
    sha256 "aed0e669305193e161f5757c9d157a56583bcadd60c7e94a74335f37c1fa87a1" => :high_sierra
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    (share/"games/dMagnetic").install "testcode/minitest.mag", "testcode/minitest.gfx"
  end

  test do
    assert_match "0be77b320a608a1778a0714adafaed69", \
      shell_output("echo Hello | #{bin}/dMagnetic -ini "\
        "#{share}/games/dMagnetic/dMagnetic.ini -mag "\
        "#{share}/games/dMagnetic/minitest.mag -gfx "\
        "#{share}/games/dMagnetic/minitest.gfx | md5").strip
  end
end

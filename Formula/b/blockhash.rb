class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https://github.com/commonsmachinery/blockhash"
  url "https://github.com/commonsmachinery/blockhash/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "3c48af7bdb1f673b2f3c9f8c0bfa9107a7019b54ac3b4e30964bc0707debdd3a"
  license "MIT"
  revision 5
  head "https://github.com/commonsmachinery/blockhash.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "297941265c168d976d6297f260117cfe2eb4ac08770e91f31be858185c7c6a2e"
    sha256 cellar: :any, arm64_sequoia: "0f06536acdfcdb2af4ca91a520ff215a60a5653f41d292da3217e5a944e68b5f"
    sha256 cellar: :any, arm64_sonoma:  "9a2282a0232e8f789e3378da993e545cd716e0973f4a13545633e0fb0f08184f"
    sha256 cellar: :any, sonoma:        "97596ce370ad99e0eef46d0d803600d2ff846757f4e4128dc8365986570061d0"
    sha256 cellar: :any, arm64_linux:   "b78247409bf305188f4d079a364735300efcd9ccc88e8deab5a4dbf3b7f8c7c9"
    sha256 cellar: :any, x86_64_linux:  "86cd1bd0ba46599943380318355167bd6ac0c4ed230b30551e8cc1a9498aea4c"
  end

  depends_on "pkgconf" => :build
  depends_on "imagemagick"

  uses_from_macos "python" => :build

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf"
    system "python3", "./waf", "install"
  end

  test do
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/commonsmachinery/blockhash/ce08b465b658c4e886d49ec33361cee767f86db6/testdata/clipper_ship.jpg"
      sha256 "a9f6858876adadc83c8551b664632a9cf669c2aea4fec0c09d81171cc3b8a97f"
    end

    resource("homebrew-testdata").stage testpath
    hash = "00007ff07ff07fe07fe67ff07560600077fe701e7f5e000079fd40410001ffff"
    result = shell_output("#{bin}/blockhash #{testpath}/clipper_ship.jpg")
    assert_match hash, result
  end
end

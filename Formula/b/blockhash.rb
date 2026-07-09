class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https://github.com/commonsmachinery/blockhash"
  url "https://github.com/commonsmachinery/blockhash/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "3c48af7bdb1f673b2f3c9f8c0bfa9107a7019b54ac3b4e30964bc0707debdd3a"
  license "MIT"
  revision 6
  head "https://github.com/commonsmachinery/blockhash.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8ab073cb0baf9057d1c34d28ac02c1fcbc53e551829f9d2c8ad390f26995cb74"
    sha256 cellar: :any, arm64_sequoia: "51e0e4440abd34bacd01a78a962ded10e9e24659f6146d16b56cfce076a32bf4"
    sha256 cellar: :any, arm64_sonoma:  "d17bdbc846bfb2d1c5e53d7eba58ce740410c76dd15963fafc4ca9809d9cdcc3"
    sha256 cellar: :any, sonoma:        "1ff1b08efeed0abedac179eeaf0d896f2b1e836d82aef89d89c9b69858ab713a"
    sha256 cellar: :any, arm64_linux:   "5a7ea035ed4e850e3352563c77bd9b9052612c8d0f4e131320b7271b9317f725"
    sha256 cellar: :any, x86_64_linux:  "b241f42c4214659ac729ddad60a9c180c6d0c26d4b2ba8afbc9e617aaff05ab8"
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

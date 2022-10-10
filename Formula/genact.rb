class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/v1.2.2.tar.gz"
  sha256 "72ead4b84e4ca733ae8a25614d44df3f3db5e47e54913ed9fbfecd2f5212a632"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5736d97990464286a4766fbbaa718f6516c5f879963ca23ecf50c5ba3fd220b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a827ee2657e36a63957913609cfdef1b3b3590030e0dda97eebd9a72bc3c957"
    sha256 cellar: :any_skip_relocation, monterey:       "7fbce14b618c1bee6f1dab5a5b60f7c203ddd5aa447e05c87bee755132e7f4f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c4791cc5620332568d337607dccc733484ff67536524d611a40c03c67524589"
    sha256 cellar: :any_skip_relocation, catalina:       "b002d8560145fd9f85c5d23ad04f6184f02cb5377ae45683e0b8cbb5d10f6bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6901c48390142402f0746ee65bb8d9ac10a6ab85525495a770799fc88d5bd473"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end

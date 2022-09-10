class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/v1.0.1.tar.gz"
  sha256 "3c25592637e0c3a6fd284bdb542656ece2a9cf2ce505724aa364302df90ba25e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccf1f172525cfd2620812211c47b3d4967ca0b0e48efb8f73ac75e8463e013a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d03781d9a6288195e28f82ef1087f1df4d6ae27fe30ee632ef4d13a710ccedb9"
    sha256 cellar: :any_skip_relocation, monterey:       "5dca3f7b33768ed950324d5253fa330477ae268670de7750f74376ac02cc0fd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfea182c118c15969e8e6bf2f7501a617e8d7b17e56d42d31e39013396a35f1d"
    sha256 cellar: :any_skip_relocation, catalina:       "f53f0dbfcf964a3e82b8bedc54e595cda16e665514cd09992893eb9f1ebc9ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8f0634f0d16e2795eb4cd337433a973340231f0c3047807e1a16de5f9cd7e8c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end

class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "1977a701afd8a1574a8a71e87d9b27337a1442a292455adafff89a7233d3cb9a"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9750de75570924fb4711902b4bfef934890dc8405ed0a1e0da5b93ec54fbdf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2e32ba2de7dd34b64b5044fe164d41fa38e5f37b1ed254500c5faa648db5c38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "773e4fde54c66adecc37ca9ed35121b39b77ff1107656ada99aa196d04d5ad78"
    sha256 cellar: :any_skip_relocation, sonoma:         "b45857b0163cd0f70d42d4652f813b9a7f12cdb2d7377157e3b9f3ab5777a1db"
    sha256 cellar: :any_skip_relocation, ventura:        "82681e351a067263822e13cd4e21425bd74c05c08af7e7e8d285e9e43bc420be"
    sha256 cellar: :any_skip_relocation, monterey:       "922f43e5cf8d73c14131973d7b0cf76e1ca767b02e5cf1e0f5deee889d7aa5f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "684273c6a9a20ce3c13e17e0804143e0c7e9664950da904731276880ad034f62"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end

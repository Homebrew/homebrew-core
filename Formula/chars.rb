class Chars < Formula
  desc "Command-line tool to display information about unicode characters"
  homepage "https://github.com/antifuchs/chars/"
  url "https://github.com/antifuchs/chars/archive/v0.5.0.tar.gz"
  sha256 "5e2807b32bd75862d8b155fa774db26b649529b62da26a74e817bec5a26e1d7c"
  license "MIT"
  head "https://github.com/antifuchs/chars.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02586356b7cee242264fc0182f5c7483f19c37bf8da4c38915069f29c68b4b04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae5975ad693a89f4d3c82809ba33f27d9387f7da07afaade8488d4d01e6460a6"
    sha256 cellar: :any_skip_relocation, monterey:       "a9a38f825fa7d6a59ba3cf38e659e5d99b56f69c8199c6a29942bc6c1e37243e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bf84510e842b1887ff71b0bb040954208fc3e190c6c184f7ee9d8fd3053cb8a"
    sha256 cellar: :any_skip_relocation, catalina:       "66d0f3de7a9eede7244c30cf630a6491db948abffed597c5754a9a23cdcd5931"
    sha256 cellar: :any_skip_relocation, mojave:         "9cee1f2bff403ab54515841d52575702ae2cd080a21bca940a0b99dafe0e20c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "878af4769fdef2626bf346316ffe28ebf3fb42deeda26c6f720eea5f11847fd3"
  end

  depends_on "rust" => :build

  def install
    cd "chars" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    output = shell_output "#{bin}/chars 1C"
    assert_match "Control character", output
    assert_match "FS", output
    assert_match "File Separator", output
  end
end

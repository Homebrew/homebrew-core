class IsFast < Formula
  desc "Check the internet as fast as possible"
  homepage "https://github.com/Magic-JD/is-fast"
  url "https://github.com/Magic-JD/is-fast/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "c3f5000b91aa89e38727c9d7cc7998e8c39bd4d87328be6835cd291ee976a2f0"
  license "MIT"
  head "https://github.com/Magic-JD/is-fast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7fad53aafdc6f26096d8b0d78e3286bb7f32a6987dfc098077860ed50a226e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f9d792dd1d3f36ce2c01d17e0a6b8ded81940594e8d86171b4c503afbc5cf10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c32f5c4bf5e5df7659d20fcf66364bfb0a5ab8d9059d7e394216357b9cc3634f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8bc007dcc8ae63a11f79e8539a05c336772ea9452b1ea28e06f3679088a3f83"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eb1fa4431d78ac13a63f70130ebda6a16703ce6d946acd52a6b0622eaccbcfe"
    sha256 cellar: :any_skip_relocation, ventura:       "12c66d548fce7cdb64c0036a2a78cfe0dd249e86bb9aa2cd1ab776ad4a8b4278"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e04a32b86ef54e608d206ae1f31a9f839eec76a0b1b706392fbc20db11468c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a4c46a3c63f91cd076e3b09986ebb0c5fdd020586256c4e2f2a4ee3ca3b072d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "is-fast #{version}", shell_output("#{bin}/is-fast --version")

    (testpath/"test.html").write <<~HTML
      <!DOCTYPE html>
      <html>
        <head><title>Test HTML page</title></head>
        <body>
          <p>Hello Homebrew!</p>
        </body>
      </html>
    HTML

    assert_match "Hello Homebrew!", shell_output("#{bin}/is-fast --piped --file #{testpath}/test.html")
  end
end

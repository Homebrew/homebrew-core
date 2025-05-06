class IsFast < Formula
  desc "Check the internet as fast as possible"
  homepage "https://github.com/Magic-JD/is-fast"
  url "https://github.com/Magic-JD/is-fast/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "d818a8c20cc5591c0966e2d59c9f239c8a347dcef9f0f1804b64c15147130f1e"
  license "MIT"
  head "https://github.com/Magic-JD/is-fast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "546640c60d2ecc1b9a38b859facde882132063d0e3d7e27849b5d2c963a6f45a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b018bd65bbaee7fc9f0feb423a71189b4f0eb5fd469f29094ad895bb21ac2f1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbfb84141997ab8ceccdc21ee03da9feb31be4b6360e46478d0d817875b54aed"
    sha256 cellar: :any_skip_relocation, sonoma:        "3513a63834eabe0c5c2441974696e1c7410f556f2f85f016b4fb5b8d2777d4d0"
    sha256 cellar: :any_skip_relocation, ventura:       "c6aa6b01e98161bd8ec209720ff506371fc40afccf74fb12abb17634b178acbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3a8c518fe12675850de53d18ec89c3172e6ee08c11c0a46a70e3e3a8c8861d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3421b677773813f2138f524911883aec2604f0a56c7abfc75e9f1bc0b9be049"
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

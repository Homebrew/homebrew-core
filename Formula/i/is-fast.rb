class IsFast < Formula
  desc "Check the internet as fast as possible"
  homepage "https://github.com/Magic-JD/is-fast"
  url "https://github.com/Magic-JD/is-fast/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "5abda366510e19852e22f4e233e38979a4ae4838515c300d73ae88e68756d002"
  license "MIT"
  head "https://github.com/Magic-JD/is-fast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28744f5f43c2d26ea40448b49d634775e5d049c7a0a9d9edf5b175e91c565dc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c6b367a9ec93bc72b7bc2fb110004aa9afbba7c7217958bbedd5cfad9593af1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a168f2683cccddea5e7f04cd4863b794ada3e5e0d45235a52fd2f1001f900ae5"
    sha256 cellar: :any_skip_relocation, sonoma:        "79335f3b1d152ee9f3ed227443a49959416109105367a50fd4c2055403a1461a"
    sha256 cellar: :any_skip_relocation, ventura:       "24ff77a42402f3cd5a08a1ceefec112816fe6ca5fe72cfc7775631946f26712c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b115a534ad23a18c4e69c935039d6827784524f13ec4a48437649ec0687c5167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbc03357c3a59c808afb0ed0533fed6e4f8a5b98e15e6597e856c2d67da527f5"
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

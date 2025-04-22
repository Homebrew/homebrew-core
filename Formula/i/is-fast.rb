class IsFast < Formula
  desc "Check the internet as fast as possible"
  homepage "https://github.com/Magic-JD/is-fast"
  url "https://github.com/Magic-JD/is-fast/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "e1fbc131960f97cd7d69d9a2bfe6d1dbb0b48beaaa950c2a5134359df7b2a75e"
  license "MIT"
  head "https://github.com/Magic-JD/is-fast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dafe45205fbc820c94453609d230c541cbebed67b2eccf3b883ff4a3227f366d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75458896799f39abcf50982c42ba9538b1ac3695b6071a984bde9bcea5c5ec4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90192f1ca1e35fe3135b2ba2efc3436e2b78818ae75df62ad9204700dafc955e"
    sha256 cellar: :any_skip_relocation, sonoma:        "678e88c0718965853be0711abf2e98f1d994920d620e480a76f7a1228366eb33"
    sha256 cellar: :any_skip_relocation, ventura:       "a5e18798ec270b7762ba56c950885271220d637b8581a833b48839efca420f3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f23ecee5a08c78b5857f3dd31d56d9e3cd2454a96bb8070baf5ca06af6d65701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b64cfb52a190d090d38852f31b906edd4a3117c32b45edd993fb43cba6f0628c"
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

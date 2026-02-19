class Erdtree < Formula
  desc "Multi-threaded file-tree visualizer and disk usage analyzer"
  homepage "https://github.com/solidiquis/erdtree"
  url "https://github.com/solidiquis/erdtree/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "1758e7ad8f7be59bc3c6bda8b058097509f9db6f40ad57c4b0b361e3be439297"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "939c66ecbf3a881dac3e9125e11e150f54e0d32140944fe78241f50f0fa07938"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b309ec7d0b9b7dda1009adf18dd271b8939fb8a9640297d725467490b67fce96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f5178f4871d8670c042b77051d309cbe668fad8bbaaa1d68a5ac104b9527898"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "332620fdd7f4f144b7f1ca64cef8831c533d8171d060239480e00119d8d0e83b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f7ed85e6c8acfbded5f12143c415dec9247026d2f7471d563393794936315dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "224ee93e7ccc07c12a2fbfd98fba58e1a500928a1dc60ac94b63f19c8013c7f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae5e2f5669bacd92df945cb69e6cd6bc64b08a70c9af6e4e4f97c770bbd7709f"
    sha256 cellar: :any_skip_relocation, ventura:        "caf7752a6c664489c58deeaa96926ed7ee4bc5135c32ffba75e5304c91b51671"
    sha256 cellar: :any_skip_relocation, monterey:       "d07e467d4b254f9c8e58467763eb847c66de701b086e844005b381581db8ed2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b380aca9a56aa3b8e44023b11cddfeecab417f8c60002e9c548541a1a4229010"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b74022c5e3a1709f26fa518ba2ce3d92206e625baf12376138a085e843697851"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7650242160244dc721565f09826b988c0397b73b4371c9216039c460c032d7a2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"erd", "--completions")
  end

  test do
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/erd")
  end
end

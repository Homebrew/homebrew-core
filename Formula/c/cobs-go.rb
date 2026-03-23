class CobsGo < Formula
  desc "COBS decode/encode commands written in Go"
  homepage "https://pkg.go.dev/github.com/pdgendt/cobs"
  url "https://github.com/pdgendt/cobs/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "042359346b2874699b0787850c77b21d6d16143aa9b298b22f980414714099ec"
  license "MIT"
  head "https://github.com/pdgendt/cobs.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"cobs"), "./cmd/cobs"
  end

  test do
    output = shell_output("echo \"Hello Homebrew\" | #{bin}/cobs encode | #{bin}/cobs decode")
    assert_equal "Hello Homebrew\n", output
  end
end

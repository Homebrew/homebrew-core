class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://github.com/neilberkman/clippy/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "27e6934defdfe662037f59e0c5b6671399abb1c14985697b876c0e17c0e2b779"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cb21da3c613663b246d05c93be7b7c90dcc3edef2124dfadb236b75512f6f49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e739d4caf1037d32eef592083ab3a85b53f48c5a9cbddba0763956e0f382c9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8bbe71e763e1469a72814501d569e72801d476dd27a9242f299641b402dbb9e"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = %W[
      -X github.com/neilberkman/clippy/cmd/internal/common.Version=#{version}
      -X github.com/neilberkman/clippy/cmd/internal/common.Commit=#{tap.user}
      -X github.com/neilberkman/clippy/cmd/internal/common.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clippy"
    system "go", "build", *std_go_args(ldflags:, output: bin/"pasty"), "./cmd/pasty"

    %w[clippy pasty].each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clippy --version")
    assert_match version.to_s, shell_output("#{bin}/pasty --version")

    (testpath/"test.txt").write("test content")
    system bin/"clippy", "-t", testpath/"test.txt"
  end
end

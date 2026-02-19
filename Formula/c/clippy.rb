class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://github.com/neilberkman/clippy/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "36fdddb9bf7713442ac395db2d1eefb80df357c12e58aa2fa6756bb3cefe733a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b1239f4dd96a2178d22cc207d304cf78f7fd8b1733e8b7a15fa72f0cfbcf408"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "805dc2884f1dd0fce6312add976502bca7d0e0b21857df6cbd84c9d58d73a005"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a8dfb2a9ede5f4a0b80f9d0e0c159097c1abdb29c158e20740685eda6cc5b35"
    sha256 cellar: :any_skip_relocation, sonoma:        "1262eebdd66411ec6c168e7d07d3ae06746aa43453e6ed24b81aaed79038b92d"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = %W[
      -s -w
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

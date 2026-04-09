class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://github.com/neilberkman/clippy/archive/refs/tags/v1.6.8.tar.gz"
  sha256 "a8469be12faf542b55693fc54b0464e741253323083a97dec379d282bb7f8eb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6757815978af472f965b1b7e5799b05745defdebabf9b4ffad149671744912ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "954d984f9438b90d3e0bcc2d019ddecdc9a812b1c4d18a29f7b28c0e11947cc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab48aff0298a15707d6ffd9b60be8a4674985d640b478ee3c13dec55461b9042"
    sha256 cellar: :any_skip_relocation, sonoma:        "34ee60100e0d8de5401014339a4da106259a3bfc69af507bdd5d611d7f056fc1"
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

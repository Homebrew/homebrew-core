class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://github.com/neilberkman/clippy/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "972f06f79678a3792900f7fdd943a663f8822e8d2f88e1c4be589ca616abf7a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7080c15bbbbc4e90ef131df4c09f97e92413c40fe8ca47172cff10ab0ac074c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87b4b272e78275b8681adf1d2448bc36eb29c21355e03268f01645faf507d250"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "406c6f33810eadf92ca040b87015293c4a101606cd85760e5f7909703ef3b273"
    sha256 cellar: :any_skip_relocation, sonoma:        "d648e9e4d8e03bc7510225c0a97db5367403bb7380e57e8c1b8814d05f15ca3e"
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

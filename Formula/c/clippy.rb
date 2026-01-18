class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://github.com/neilberkman/clippy/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "a2964c9247f32ea8c84c38b3d57047187cdc0f3848075199f1145a2c13f89091"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "009d4badba9d84dfe5ce4c024bd7c81eed98f79b72034be24a4f7db8790687e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb742bbeb3b1a2e5c65a5719eda9f4190b27cbb2a7124a9da62b2ca5c15b930b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a80137dcf9d74ab7c68d81b144ce42fa1800ca8b20b2b2bd01c7a6efc6970dd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f941a40a5a3e6ff634ae322370dd43f555b5f8266015b897b29125daa702bf7"
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

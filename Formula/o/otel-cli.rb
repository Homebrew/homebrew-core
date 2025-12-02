class OtelCli < Formula
  desc "Tool for sending events from shell scripts & similar environments"
  homepage "https://github.com/equinix-labs/otel-cli"
  url "https://github.com/equinix-labs/otel-cli/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "331a76783974318a31d9ab06e3f05af488e0ede3cce989f8d1b634450a345536"
  license "Apache-2.0"
  head "https://github.com/equinix-labs/otel-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c6c809c63d335d997e8f794037c3188bf3d5bf1eca2e2a1a533e78616b0eb80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ae87c2f9fafe21f6f99739e0d86b3e0f1d70bb75c355e434f911d58150e1f01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ae87c2f9fafe21f6f99739e0d86b3e0f1d70bb75c355e434f911d58150e1f01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ae87c2f9fafe21f6f99739e0d86b3e0f1d70bb75c355e434f911d58150e1f01"
    sha256 cellar: :any_skip_relocation, sonoma:        "8184d3d001f134321d8d3ceb6ea5b29d61bf134b189ae9206e275010a0f9c6c8"
    sha256 cellar: :any_skip_relocation, ventura:       "8184d3d001f134321d8d3ceb6ea5b29d61bf134b189ae9206e275010a0f9c6c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9825db7c6bd24d790f1270d5f2aadd3c9e96472743016f216554caccbec5edff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb6e8b16d5493b5443bced5761cfeed0322e32d2cb043f83ac4626e5c80a4d22"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"otel-cli", "completion")
  end

  test do
    output = shell_output("#{bin}/otel-cli status")
    assert_equal "otel-cli", JSON.parse(output)["config"]["service_name"]
  end
end

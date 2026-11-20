class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.58.1.tar.gz"
  sha256 "c151f45831cdbd23e43f7531bb0e3126c6b3546e83c56da80d3c10b243b1e0fa"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b64ed33f643a05451bfa675480dda7ba4b392265e8aebae2e4e803efe8710a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ce15f14f226a948c4079cd1954e57d170ddf50320c552fc3c37462d10b69a11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2a15cfaa189386a0694ace67f2b8dfdea5d502b0e7688cdf2a690140bc6d95d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "154c4f8f8583f1561da225860d80449026d65af52d04003d7bbdc82f64e8ed0e"
    sha256 cellar: :any,                 x86_64_linux:      "589871e8d7e43663efbaebdee16eedb080b30fc6308d10ca1224120d5b939758"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end

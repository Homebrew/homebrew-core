class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.43.1.tar.gz"
  sha256 "e1c4100713d6937c467cc92ef0a567a3f0549cd17770976d90cef1e6fa80f17b"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1fc9182c60f55cd5b55d1805fd7260391dea0a06842c8cd101ad7e450bbb92d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8f6cb64be0d6a4641c66197fac8334b527ffe7fdce6b34158bfdf1528a76a428"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f40c3f6afda7e33986d49e40612b7f1213cca9bda74dc88b4aedaa9f74ec19c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "75289f108319728d62b6d0164115a392b4f5a6ca0e750296e48a59b48e50a0c5"
    sha256 cellar: :any,                 x86_64_linux:      "0c5a0e870806ead4a4cc35f026891505914f039022eeb228e7b45138a4f26f45"
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

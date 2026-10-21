class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.48.1.tar.gz"
  sha256 "66a741852769568a968c2b73f2861aed339e0f9597b9d2b51a148c7b17dcf9be"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c69f1bc47c4c18d4f0af1401ff3bff2f0a98482ddde88de5e33cf94c5951cc1c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07763620e89141c519364c8f4a10f55cf2fd667dfcf1641ccc7fdb013823a451"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "47b46bdfc3636a9a3b7b812910caa81d7e98c7889e388156ef1ec39a86c00f59"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "280d6cbef5496cb9d2052cc4d95364b9b177e312b8c99c015c3185e0fff581cd"
    sha256 cellar: :any,                 x86_64_linux:      "83563afca72c36f82d50d616bf5532026e88275d4d04191e387f87f20c0df55a"
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

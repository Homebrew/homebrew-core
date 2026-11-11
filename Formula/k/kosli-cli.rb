class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.55.4.tar.gz"
  sha256 "106195321541a49a1037b832325a34e356878e4ccbb1767ed3277fbef3ffb066"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d50730f3e4180922061187686e048fbe2b7bd94afff1c7fbef2e11403f001658"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7e23909023ebe10e972339e318b6519d8dc070bc4f40e7b0885a0c21b49ce1cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0815b481ed6d0a53971128a2d1ef4513af99c089736ddc536f43132e7bfaf789"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cff70efbc60ea40887a0f54080779861e9380230f553bc1edcdc45f363f9c3ca"
    sha256 cellar: :any,                 x86_64_linux:      "36b35670f8a62f0d09774a57b1e81cfb2c4f82d5a21343b7b9cde9a7ce40575d"
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

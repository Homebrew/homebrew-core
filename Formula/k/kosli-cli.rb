class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.43.tar.gz"
  sha256 "cbe0b7511f73c492e3590527703ca83fe1654e9832a48539a0e13a2d38fbe022"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e03cdcf8ce7c78a620071cf4077f5d6799f2c589621e883a421db468e60a3dbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26f23707472552a4a0bfebeb2d6575c58e2c99e77289634638de5cc52ac1cc0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23dda33db619db62560821de2aaf997b2b5898dba38cdcef14abfb915e34bed2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5379566c087736128a001dc7fd2f6b92d9f4b7e0983bcd64af0c915509e5c6f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2c4a27b251da880baf2a35c06d5c06e7f5e361663d2f6d5141b4c34ba7794c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e68552766b55a7dda40647ea34ed4cdeb696e84d5f2366553fe11d8f16f60cb7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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

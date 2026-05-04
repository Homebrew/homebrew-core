class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.17.5.tar.gz"
  sha256 "2867b97d26e873145a066a0037c24afb2fd1f01684eed25a836907719e922e65"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be10fc001eb8cb266d6772016b9d7c2da63fe448ec8e8563a542bdd64480c058"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fc988fc780c865256d57228193585972b8b0a834f4c71bcb82e86225dd92ee7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57ebf91097881afce0be0e7b78b22c3b5ecc59a2af689fece52a0c1d94c10119"
    sha256 cellar: :any_skip_relocation, sonoma:        "921bb8f3e5541eef542eb1dc729bba093682e44bc79baa26e763dc172a4cafaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "531216d7d6fbd3aca770dfe2660c889eee68f0d04a39fc2f2c136a5cde1a831d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "530b648e2e7ab996c6ec0d41cde15970c11951490e6da7b258adb3d6fe001a4d"
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

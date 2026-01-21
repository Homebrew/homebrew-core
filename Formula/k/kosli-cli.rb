class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.39.tar.gz"
  sha256 "81e1b5a7b8043bd293a7e46204c1b8bdce6367ff48b8837a68429f86597f672b"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7718a056c54db21d9f8257683139e40eea57bd6694b5d1d0e5ec30beb266fb92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e21e69bf30140dd5e870fa734aa9561efed284614daff44760c6f84ef10b23f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25157965e44a68adf1133752bb6a6417c6094f906fdfd28e74be2f2a6677b47b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec8cd931fb2a915f892ee4f93c8162b0289447910463a9a746884ccc186095af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03a95a05773a197d539fcc9b990b2372e3b2abb7abdc32d07a2e864ee3d58cfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81cfc9967631d45aacddb55f22dae0083522782ac8f72d41a03d9d129ea1d77e"
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

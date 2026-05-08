class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.17.7.tar.gz"
  sha256 "bdc97699a5b83e4484689caa151528888f46a680e7fb0056d62e3bdc520eca75"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "945a6122f07b3501aa13a91a1f331635c552fa13cbcd247782d026b8ccb7bb8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "963d18bbde2cb853f636900e069d8b8a52e477cbb92720ec65fb6623c94146c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ae923a4703f19e294dd6ac02067bd8894cc92fcb2b0fc77a2b3d1715ad86478"
    sha256 cellar: :any_skip_relocation, sonoma:        "458bc6de99fe7613142b7e6f1f9b33bac6bef31d461450ffe42eb0d5e1a4e5fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd6c582958274b2ed6a448914896213385f71f867223478a78193968b0ccb195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96dbca74133edbcff66d365b947c2bbc3129bf418aec57ef76263654410816d0"
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

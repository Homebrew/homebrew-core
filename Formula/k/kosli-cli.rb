class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.34.tar.gz"
  sha256 "efb485907560a311aa572f08791bc4345a3160cf1790a3151d13ca53a1570b2a"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "767a6462482d1090d0ba634aceaec77988a74a1bf770bb5d245a15a1036ff916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b65102785d2cd70b742e0a505b5f2cdc3cf2ae5b3cc30bd3e7303e823f1050f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dff229f7b757d7869c873436ca43700723f0ac45f4efa2d555ae3df2b157ae72"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd1a3b54de541b7db27a22899f01b3ce5c34e51706b17e5736e3f2283fe3ee87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aea3dd3f06513e8618dfba1aba9a4b46e834fc49f33389eeb4f994e93357c7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67a5e5c40a576d16533a9ff421cff2e3683adbd4f02a02d29109ee05b175d7c2"
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

    generate_completions_from_executable(bin/"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end

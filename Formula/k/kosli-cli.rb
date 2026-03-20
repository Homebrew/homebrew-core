class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "aca89441f907c1106ec839f7713de30c69a836087a8805d67db910e6e5992910"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31a9d24731451f9a8138d3118f20258b9bbd2fd3005f2d2d5f82d2fd50c6ad1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ceb177bf4f9d6bea527e073b9af630ee62635b0e4527d002c1fee41e31d3d669"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a26e14016c2a31a0e5a3c1975926d530dd48e9a2c6ad0e7d2f21ffbfbc3634e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f35c0fa3a69fe7db353796407e85bd0e81763f55a9e5a1410c21022f644f143"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a037495093a0780167d750dd71b2f7641dcfb7dbb3fcbdb96ac86b66128a212c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00a7e3b768a7fab3469bf235fcb3028f4d43e9d4b0b6abcb4ddacaa20ce1ea3d"
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

class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.8.8.tar.gz"
  sha256 "c7ebf3a2d7fe1a3504f26612e8d3c4382c0ad63d14885ea3fdbe22c519a97cf1"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a771c5e649f94e13494b6b5c077c3ebeb8c3947dad8be7401da3cd6734d78bf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19c204616b35ef0317a737d3ba7ccb5428e58640bf786069932d4b2cff7beceb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d37951a56dd9a36be308cc9ff8443facdc0be8b8886dec093dc78cc85b6570e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fbc769a950c4d48de7fc3d57ac1434336f7333e4e3a7b832f725092d2694e02"
    sha256 cellar: :any_skip_relocation, ventura:        "fbe9124a318e8cea7be42426b99173ad2713ba3460bfc95d02d9ea634e39ad01"
    sha256 cellar: :any_skip_relocation, monterey:       "2fa2d9f651241d1fa2badeae2a11950cf8685fc3efa1760b12c1bf0e34dae6b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d828aedb214e174b1a51f2acb7840ace94a0a6f868f4ebd3c23c268450d836f1"
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

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end

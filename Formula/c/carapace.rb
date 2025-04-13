class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "0ef69e42b68a421f839afbc433336ccfa761af61347cafec98414117fc363b33"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c67c3397b14a90d7dcd0667e816a52e54ed59f826376b8bb7981187c2b36f858"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baf67c0cfa10d58ea7fd9e24a7c2f854d5fcf092afeab61925129c8bec4d609d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0220e33a22c6c74cc00575db72100a5ad969a7aa63533179164c7c82a40c8e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b1e3e0c16bdf062ecc500c6b4c179f0723d078d239c28135421ce3ad8222164"
    sha256 cellar: :any_skip_relocation, ventura:       "3199ebbf850f55b6557d338b89502cb1c69fcfb633d521fddcccecd9a88f9534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f91d092ae15b4172c85ee50d981cd8648093b7ca4889f0af8f9cfa43e170a2d8"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "_carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end

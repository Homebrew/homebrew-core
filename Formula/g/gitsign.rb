class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://github.com/sigstore/gitsign/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "e08d3ff93fdd551683b40028bc05a9bc34e077c44bfb88099db9b1027a27131e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d67dacc2ed04be9ac1651fa7d5ad2939c73c22313c8cffec1ef591c595921260"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9571b37627fd1af443bcddcb60bba2d71d15156c5cbd7caa0e506f5431f162e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6e771cf8b14f9be086fcd16f647562a73c4c1b1549a1658914fff0823caf061"
    sha256 cellar: :any_skip_relocation, sonoma:         "0eb7f9483a8e4b7429d79d962ccb96e0e7e56bd3fec3f00065c99c1ec0b3bb31"
    sha256 cellar: :any_skip_relocation, ventura:        "f1e6093eda77e94b84896522078394fdaa4322b3981b0e4b3d8bd108b9749d75"
    sha256 cellar: :any_skip_relocation, monterey:       "8004f3594c4405ff167d5f78d7da6ccc2188bdd929db63b28c67713ab930d549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2f08d85a7b5616679898311ddd8c5be8b6b7c3fd55366f2195aa72289cb70c8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sigstore/gitsign/pkg/version.gitVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gitsign", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsign --version")

    system "git", "clone", "https://github.com/sigstore/gitsign.git"
    cd testpath/"gitsign" do
      require "pty"
      stdout, _stdin, _pid = PTY.spawn("#{bin}/gitsign attest")
      assert_match "Generating ephemeral keys...", stdout.readline
    end
  end
end

class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.13.14",
      revision: "07ee3911f65dc978899f036586c7a99317a31996"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b87a1bf12fc9ee451a0b53a25cfc4310d661c5dd07948b7b21b79ae9b7dba2fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b87a1bf12fc9ee451a0b53a25cfc4310d661c5dd07948b7b21b79ae9b7dba2fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b87a1bf12fc9ee451a0b53a25cfc4310d661c5dd07948b7b21b79ae9b7dba2fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e7645f21da208f50a433e710f270217848e817d2afdfd2c94952e9e8f0b16778"
    sha256 cellar: :any,                 x86_64_linux:      "00e3e322c3b6b653fec8845dc1a177f80e82b10d7c1224b4c32cbdee84a41746"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ldflags = %W[
      -X github.com/alexellis/k3sup/cmd.Version=#{version}
      -X github.com/alexellis/k3sup/cmd.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k3sup", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end

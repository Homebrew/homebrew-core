class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.13.11",
      revision: "5e5228b9d25c8c3dd1bb82d0f78a3944933529ed"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4836e183e365653092b8d6370886d71dd7102b865925232f57cf4d4ac1b1220"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4836e183e365653092b8d6370886d71dd7102b865925232f57cf4d4ac1b1220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4836e183e365653092b8d6370886d71dd7102b865925232f57cf4d4ac1b1220"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1a76ab6743188fc8c6251f7b4204de39dd356cc2ae88b8ecb7a7f95525b2829"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e8052bd6c2f018a0736c17237ff0939d73fa2486abdb7af45760427c9afb8ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ce6015bf494e8bd40cbe78779b01821b20e53b975cf3b4d30993d2183ca2bff"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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

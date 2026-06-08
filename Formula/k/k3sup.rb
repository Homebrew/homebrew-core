class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.13.12",
      revision: "ce927dd148cbc42f75fb3dd44f8836b4d3f9a0e0"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28a9ee3f378c4c3d7779394f1874f928c4cf5998e5872b6cedc81b368e632a6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28a9ee3f378c4c3d7779394f1874f928c4cf5998e5872b6cedc81b368e632a6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28a9ee3f378c4c3d7779394f1874f928c4cf5998e5872b6cedc81b368e632a6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccfabb4d5060daf24b3be3459208a056ea73a7e2dd05d6bfb4dbcf7c050e180d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca5bcf145ad386bf836f92cfdd57aeae600d146bf6b9de7b57d7be4a4d5b900a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0a1700b591de02276fcb18db949915000da6612f72a954c127fc49a1344e5a7"
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

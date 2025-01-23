class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.13.8",
      revision: "ac8e81477f83d2752295fbc7fbd4a2f6f04e7055"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f81f7777a1e1f345106e595b7ceffe60aa5bbcb0a9834d3f58eb85bd3c82f9f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f81f7777a1e1f345106e595b7ceffe60aa5bbcb0a9834d3f58eb85bd3c82f9f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f81f7777a1e1f345106e595b7ceffe60aa5bbcb0a9834d3f58eb85bd3c82f9f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "80db85fd32871b46186ad6ac54059ca2eb2a5fb85424ea2107b86402f1cdf8f1"
    sha256 cellar: :any_skip_relocation, ventura:       "80db85fd32871b46186ad6ac54059ca2eb2a5fb85424ea2107b86402f1cdf8f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "850bc78212e8626eb5062a6589991c31bcf0f02c88485bf615d7b6b07ee9255c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/k3sup/cmd.Version=#{version}
      -X github.com/alexellis/k3sup/cmd.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k3sup", "completion")
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end

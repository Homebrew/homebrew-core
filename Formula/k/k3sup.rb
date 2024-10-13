class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.13.6",
      revision: "752c22af38d11b9d57f7a5ae4add3571d0d57b3a"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a335293332105e9a9182c8abc14a52462f96c8d12913b8cf54871dd76e731bd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a19a3f026707f71120c5a36b094da132fd51394f1eb2e6967844e1aff130dc0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "666f7e1ba2f484cd268d3b51d88efe491a8743cf11a62f9b7bc9b609a7f98719"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc52230412bfae0ec53251681bab7bb399c74271264e83a9b4636dd146ede547"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d0292f1177753e635a702c5ac619ddc034139bcf8a711740bcfbf7803312631"
    sha256 cellar: :any_skip_relocation, ventura:        "58731470c139141350cc584b5ff795231e291f00a1b72491b7988388a137d054"
    sha256 cellar: :any_skip_relocation, monterey:       "6f9d1cbf0d634d53b89a8b3b82b5a57c432aaad76cbfa6ad98f163264b195e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8f9bb3779f6a239d5357bb94554da5a1f0df29b038dddd255143110277799e2"
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

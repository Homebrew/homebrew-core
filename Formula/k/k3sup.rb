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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48d5c8f6cbfb13d9a7fce43a84e4ee9b60b40bf1b21bb49843f0b6733b881b11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1bcfb7804eb82de0455f8423e2d25449b2cbbddd4830df77835c9fbec8b2a10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1bcfb7804eb82de0455f8423e2d25449b2cbbddd4830df77835c9fbec8b2a10"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1bcfb7804eb82de0455f8423e2d25449b2cbbddd4830df77835c9fbec8b2a10"
    sha256 cellar: :any_skip_relocation, sonoma:        "325439e20d09e3bd86c280f4a72e5c807847c30f9f2be4b9dcc7f2a13c37a522"
    sha256 cellar: :any_skip_relocation, ventura:       "325439e20d09e3bd86c280f4a72e5c807847c30f9f2be4b9dcc7f2a13c37a522"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ed69b9d8fa164779439bd15965236b85301c72abefc974539e575051624e38c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b80a466b7a3f7775225d578091d3d1e9c94439c96a4fa17b25dcbc5fb693a07c"
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

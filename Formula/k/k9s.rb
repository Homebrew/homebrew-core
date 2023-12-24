class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.30.0",
      revision: "dcec53e061ec3372a62e945b8afa44640fbbebb5"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df83e2f14124619ca114c67978a086be9a5312dcade9553a221005f6285df4ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82d7b22291dcf78f7195c6a009e509f13ebbc8411cbd3628d493b4e99d8386ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c1621e2c4821e012d0c081efe576634ecf29288c4562e22a097b40b984a2cb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "a221961407031e7b46e7093dd28f82bb66b05a68900833d8446141400df9ff59"
    sha256 cellar: :any_skip_relocation, ventura:        "50359e8f8ac6e06ca72107c565be8a2d996c739b83922f5e3a6a579cedc666cc"
    sha256 cellar: :any_skip_relocation, monterey:       "6cacf9e5133544ca1e17760c0a1bdd2ce8dda1bad99da8544b5f4caaa5724db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6a48e473c44dfb89aacdcfdb1f93151eb978cd1a1067565cdcd6fdff5ac8c05"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end

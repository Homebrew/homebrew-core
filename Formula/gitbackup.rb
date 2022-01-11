class Gitbackup < Formula
  desc "Tool to backup your Bitbucket, GitHub and GitLab repositories"
  homepage "https://github.com/amitsaha/gitbackup"
  url "https://github.com/amitsaha/gitbackup/archive/v0.8.0.tar.gz"
  sha256 "b94bc7c55b5c086ba1504adceef74d0f0eb8c159f94cb84b23863e97f74fe217"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9f5dd67f2cc158ef3e5735884b2aa5e51545020fdf1e048a685555cd8ef434d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9f5dd67f2cc158ef3e5735884b2aa5e51545020fdf1e048a685555cd8ef434d"
    sha256 cellar: :any_skip_relocation, monterey:       "464f30bd128dfb46f01bace2f652a9175c8d5dd03ce8d997ae03acb92bc8662f"
    sha256 cellar: :any_skip_relocation, big_sur:        "464f30bd128dfb46f01bace2f652a9175c8d5dd03ce8d997ae03acb92bc8662f"
    sha256 cellar: :any_skip_relocation, catalina:       "464f30bd128dfb46f01bace2f652a9175c8d5dd03ce8d997ae03acb92bc8662f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "190d3d2addb023320b4a9e82550b51a912b2fbefa8ccc4f6fe29b335e80a8a44"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args
  end

  test do
    assert_match "Please specify the git service type", shell_output("#{bin}/gitbackup 2>&1", 1)
  end
end

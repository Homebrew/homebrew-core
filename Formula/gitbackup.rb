class Gitbackup < Formula
  desc "Tool to backup your Bitbucket, GitHub and GitLab repositories"
  homepage "https://github.com/amitsaha/gitbackup"
  url "https://github.com/amitsaha/gitbackup/archive/v0.8.2.tar.gz"
  sha256 "a216fc96cc80c65ed72a1b50f77697c2d6cb18f4cb849d8dde67f65d24951adc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26cb3a093f1ceb46e50334cd1907f45698d190729d5939b23acbcdbb2be0e0cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26cb3a093f1ceb46e50334cd1907f45698d190729d5939b23acbcdbb2be0e0cf"
    sha256 cellar: :any_skip_relocation, monterey:       "9b6a33e3586bac4b7785d4c33d08279844a5e90d51c820e76ccd942b504b4bbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b6a33e3586bac4b7785d4c33d08279844a5e90d51c820e76ccd942b504b4bbf"
    sha256 cellar: :any_skip_relocation, catalina:       "9b6a33e3586bac4b7785d4c33d08279844a5e90d51c820e76ccd942b504b4bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a4ffeab3bd218563d2c43891273a95925bd8cbd24c325689af09d18587d4ffd"
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

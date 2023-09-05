class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.32.0/cli-v1.32.0.tar.gz"
  sha256 "78b90070d915e44671b3c36ca248dd34c5c079a5ae6670c4edec84571ab6e5c3"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "696a706d9e68d3900416891708fc32906777710da3ffaf5631197f4d777b9858"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16c062edb1ba2c948177c0e439eb62fab57ac9ae3ddecdbaf8e8baea7505767a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7672b3fb07dd4e3beb5bbc61c92cfe5f386046ad02b50799662ff66a8e5d8679"
    sha256 cellar: :any_skip_relocation, ventura:        "dc2a07246a892310d87b06ee0dc21e9710b37977bd18a7586bc8478db585a929"
    sha256 cellar: :any_skip_relocation, monterey:       "eda859d3620ea9023d1b2ea63dac32e05ec29a9c1a6733272f9661c41b9ecc53"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ff9713415ccadf1f85ed66c6a6c68ef709ddcd861130c98e1a88476c67a12df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a530eefee007090d1e99ca8b46292b39540dc292c7c71d74460cf0297378cb4c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=v#{version}"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end

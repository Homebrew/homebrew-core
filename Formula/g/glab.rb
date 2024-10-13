class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.47.0/cli-v1.47.0.tar.gz"
  sha256 "7661d180a6d45efc3095fb1994eaab9b63c822eddb67093d4136149b26cc28a5"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dbc46a6be7adfb977a4e2fdff718d853f7beba4945ff69124efbe777db55947"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dbc46a6be7adfb977a4e2fdff718d853f7beba4945ff69124efbe777db55947"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dbc46a6be7adfb977a4e2fdff718d853f7beba4945ff69124efbe777db55947"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ec02ca0e5096c8f0d675789df59f79f1ebd78fb82021c6055106fbdb4c45e9c"
    sha256 cellar: :any_skip_relocation, ventura:       "9ec02ca0e5096c8f0d675789df59f79f1ebd78fb82021c6055106fbdb4c45e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1685fe2ff295a4ee50d665feef803887aefbee1a6733becd6f2196fb762c8e0c"
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

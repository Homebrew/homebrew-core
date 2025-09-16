class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.70.0",
    revision: "440dd5a9a2774642aeb82560cfa711b47f67062d"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a577eafa54c3155305f3fe63f49e01ecec130d0bff77972ec7bd16af0a777ff5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af7a27112f5da3009868843bf89d04061f92002c9f27d5f3a999c4777fc4a6ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af7a27112f5da3009868843bf89d04061f92002c9f27d5f3a999c4777fc4a6ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af7a27112f5da3009868843bf89d04061f92002c9f27d5f3a999c4777fc4a6ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbc5ac1fe455a2729cb23b73e7b5c711bc3d17e0ec2c4f8ec00e2782e497bd62"
    sha256 cellar: :any_skip_relocation, ventura:       "cbc5ac1fe455a2729cb23b73e7b5c711bc3d17e0ec2c4f8ec00e2782e497bd62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76e9ca94b9060202e5a14bb3b1d262f5e645bb67b407ab552a364df8c1b7791a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fc76548381e1cac0c6c33b0c879ee7634bd78bf7991964bc8173c806718ab8d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
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

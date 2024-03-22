class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.37.0/cli-v1.37.0.tar.gz"
  sha256 "f945c30f5946a8997dbc7a76ea434e312d1292902e47e44f44f1ff5696bf910f"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f27de81fe50aa89400c295321f0246c1086e61f938b004221788ca31eb965f05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4c46ae9eee7ad5666d5ce09de9bea8df122db4834eaf08d6cfa1fd447261e25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "548d6303af60eff25735ca30c68dbede60454242057e9b625352776c9c57fbf1"
    sha256 cellar: :any_skip_relocation, sonoma:         "f33bca65882a2c433ae3fa3eb309927caf4a114f97e733bd3b8c3d0db3f1d470"
    sha256 cellar: :any_skip_relocation, ventura:        "72e56de357a502fa4bad918ae9fefb1bbc3e85aba3024521c9cacd7d8970bc2d"
    sha256 cellar: :any_skip_relocation, monterey:       "7ab0e71b3fb557b5419f4868f9898102e6577992b8d96ebc937476819182725b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bac3615447001acb2a9d4debbd0c12fc6b88b712d6a96710469d00db9d84a7c9"
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

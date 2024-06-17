class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.41.0/cli-v1.41.0.tar.gz"
  sha256 "3531455facae3a9695e2826277040157e8a337ee7eb7e212e054d7ffc61bc7db"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56f4e2390bc59dff4aa8aa26761c0f869cdf7136616fb2ed2861fb3423bc45e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f562deafccb25c0a3fc801d1ea4717f97e41e6ed8abc1e27d9d268404721230"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f73cdb965187677e0ac998488fd2ff084422bf7049a1ac2d88938545438e5a11"
    sha256 cellar: :any_skip_relocation, sonoma:         "5868a75e25ebb3651f2755b9a8a8feaf17cfa8d11d0e0ffd9143727d3e3bdb6a"
    sha256 cellar: :any_skip_relocation, ventura:        "2c67812a1e87d906d2061954830ba4ade3a8da6406a8f925eb6e8ad979de3880"
    sha256 cellar: :any_skip_relocation, monterey:       "f9e46c0005b15d463141f484ac8c26ad7ded9a1a86b0bd544cabf6617d58874b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e17da848e062a44613aa050b18cc085078989511ed3dca7d14af1379d91ce59"
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

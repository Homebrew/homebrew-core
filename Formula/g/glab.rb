class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.36.0/cli-v1.36.0.tar.gz"
  sha256 "8d6c759ebfe9c6942fcdb7055a4a5c7209a3b22beb25947f906c9aef3bc067e8"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e5215e48b8c2cfa792f56ba2d9677ba6141ea91e2b5042fbbbc9fef36f782ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4aeb54e4b29e628b9d00e835e01f41e2b776b703476c976e93162f288c86e6e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caafa880ad9084219a26f5acb5f55da8c72e423e2086cee489fdea9574a4a21a"
    sha256 cellar: :any_skip_relocation, sonoma:         "38be367adef12b5d66ef8230e7fcdd4e298b2bf064ab65ccfa913cd799a31183"
    sha256 cellar: :any_skip_relocation, ventura:        "ed24e1fddfa5a1d0f54a2b4c33a334374c0b50ad9883c39a3e3f827f8a35af36"
    sha256 cellar: :any_skip_relocation, monterey:       "edc0a351df68a0f1bcff4d347855b35f03d056b445e63b6b7126b0f84cc2c734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "090f9e56afacfe7250ee60b7c0dc4896110faa679e81676384fca45920c59f45"
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

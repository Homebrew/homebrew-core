class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.48.0/cli-v1.48.0.tar.gz"
  sha256 "45410de23a7bad37feeae18f47f3c0113d81133ad9bb97c8f0b8afc5409272c7"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "561296afa52ab886e98fc46d8685cd8a3f32167df80cad57636f0e74e5068f39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "561296afa52ab886e98fc46d8685cd8a3f32167df80cad57636f0e74e5068f39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "561296afa52ab886e98fc46d8685cd8a3f32167df80cad57636f0e74e5068f39"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8fbedcb24cb32d4bc0805437d076ef68df219d1b3036d0a0acaca3f6a87cda9"
    sha256 cellar: :any_skip_relocation, ventura:       "b8fbedcb24cb32d4bc0805437d076ef68df219d1b3036d0a0acaca3f6a87cda9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4cf9d25f2911f88dc61ace03ad81038725e1a37f70a2e4a0a780bc31a9ff8a8"
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

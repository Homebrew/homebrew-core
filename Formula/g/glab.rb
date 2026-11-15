class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.130.0",
    revision: "9b430a11f95ec78d87f19be071d1c381d8803630"
  license "MIT"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "829bc24a819b48e3e9a3bf541f79c61f8ee4db1f91d40cdf268bc2c494a9da9f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "829bc24a819b48e3e9a3bf541f79c61f8ee4db1f91d40cdf268bc2c494a9da9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "829bc24a819b48e3e9a3bf541f79c61f8ee4db1f91d40cdf268bc2c494a9da9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dd24dcc2d49ccee24beee51fc213cfa434be2edcdcf83a08ebb407f61b42544f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a80599122f8596bde1ba46d905f2fa66408648af4e63cf4be9b371e35fc74945"
  end

  depends_on "go" => :build

  # `test do` block queries the GitLab API
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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

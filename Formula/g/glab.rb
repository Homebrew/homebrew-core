class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.132.0",
    revision: "00f5b8fe102e1a07471aadd5a2e44f6ff1befeeb"
  license "MIT"
  compatibility_version 1
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "48dc4ba1e30d7823729e544d316bd6474ad61af72ebf1d88f79bfe63b1145696"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5e706cea6adc85d144b39b75ff33cd5a7216c8e5a790a719e733e7360206cca7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5e706cea6adc85d144b39b75ff33cd5a7216c8e5a790a719e733e7360206cca7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5e706cea6adc85d144b39b75ff33cd5a7216c8e5a790a719e733e7360206cca7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e85f0bd27a659fcc4c1ca322826a4b7c6192a98db9b4629e0df3883d79124ddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e430e071b629b61481d16e769efd76d3cf7ada86767c5048719f920d573779c6"
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

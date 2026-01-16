class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.80.4",
    revision: "f4b518e9120bb54002d9cda816d3011de757feea"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "142c98591f6fe52cee979dcb7f946efdac073472415cb2c9f3df36c01b74078e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "142c98591f6fe52cee979dcb7f946efdac073472415cb2c9f3df36c01b74078e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "142c98591f6fe52cee979dcb7f946efdac073472415cb2c9f3df36c01b74078e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9cae58659f27cd3a019d8b8be88229cb2d700e30cdd92b0ad9b8d2fe822cc5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30772c8879c48765e2b66a97b6de6b233ab7b947df1c5f48ed59235febea0168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "338315b5ce76b17211cbc9958b8add3c6c579ed773ff6c03dedd2e01ac21b243"
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

class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.28.3.tar.gz"
  sha256 "fac655ab9eeb5b5fc5301e7d8f30bbe8cabdd394186969fb2aab23f62da40c5c"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dcdb96828706cd41642f1126042e15f2606765680321fe89f6a11dda3336676"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d679caa574ae3936a45dc7b73288645b999b030916a40028571a14eb6c47e05a"
    sha256 cellar: :any_skip_relocation, monterey:       "fb14a0017f9d692a6d9cd4e08741953eaba9c2bde1780f959fa4d8f743bffbbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f26c0b5fcfb829df000b8209133ab832f9ef339266efbd9c04ff9a17cd5813c"
    sha256 cellar: :any_skip_relocation, catalina:       "e2f10ae51ef70d4d3c1ef5a77c028f964f27549926d97f8f8295172daccb7901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5bcb6178c47e2efa6424174dc058b5afafff8e9c31a7298299beb9e5d37ad44"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")

    bash_output = Utils.safe_popen_read(bin/"conftest", "completion", "bash")
    (bash_completion/"conftest").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"conftest", "completion", "zsh")
    (zsh_completion/"_conftest").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"conftest", "completion", "fish")
    (fish_completion/"conftest.fish").write fish_output
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end

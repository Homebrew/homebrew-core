class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.28.1.tar.gz"
  sha256 "7db4d07321afe713b735c347b69a53adee193c728fe655ab2027c94439c53a5d"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "14e2418aed581f427b19637dc5190ac121b8be4f69e569e6a5a26e3fd744286d"
    sha256 cellar: :any_skip_relocation, big_sur:       "67813dba27b436619a69495e7313ed0b7bf8f292f627d13e2e446463424318c0"
    sha256 cellar: :any_skip_relocation, catalina:      "d6d0f3239fe2e0103bcb80004ff38b8cb80dba708c6acec73ff35e6142840317"
    sha256 cellar: :any_skip_relocation, mojave:        "3a624ac7e19423d2ee7bac2db0b41c8308b24a43ba1eab6e7e0518f263652278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f1990a8c26abf666a468648eb1d5ee7886a647b4129dfa46aadba5cb618b407"
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

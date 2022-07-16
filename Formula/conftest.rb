class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.33.2.tar.gz"
  sha256 "18a71b1c32f7891bbd8a1668686f0505d95d83537e9bf4cdffa2d257d924b08a"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9557470d7cbbbde5001957d52a757fd59a9646c914d988fe75207a31b4f502ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa70ed17d0dc78f9c9d2d72754315c15a081334b7bdc215a5cd99ffd1aea6dfe"
    sha256 cellar: :any_skip_relocation, monterey:       "f9b09de8dadb64fbf3d21ff6e5cb9a2eb110ecf55ae520a546edf7656830371a"
    sha256 cellar: :any_skip_relocation, big_sur:        "91c0979e23b020c2318d8eff59e96629f16e264ca67ac492a083baecde8181d5"
    sha256 cellar: :any_skip_relocation, catalina:       "1e1d6a4352882d90f800e8d0f55846a6bbbb874a882df091ee9cbaf89cb56d22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfb722e92f96895b64ced7457b14e56b776aefe0000ae075416a473bef3829e7"
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

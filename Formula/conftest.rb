class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.28.2.tar.gz"
  sha256 "4eb1d8ee03e659d12f3df7b98d816bc70c0ac04765574238c4d8153f54524cf1"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f5132b499691b5f9e18fa6bd2f709a1fafe4ffc72286d1cb3cf073b75f8b696"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cb0b9196343051681c02ebef17bf5a8dfb880211add4fe11ad37bc6dc2d7ed7"
    sha256 cellar: :any_skip_relocation, monterey:       "26316248243b5efff29fd59528181fb7a5f3aa2728b5a4565ed3ab0ba6b68d03"
    sha256 cellar: :any_skip_relocation, big_sur:        "8626fca742db1f04a8d0e31e9beb3324ac243b838fabddc93af2e2e9d8b67b36"
    sha256 cellar: :any_skip_relocation, catalina:       "afd6c107e5f61e5fe16f2680a69e4e0660e606202c708ff68e7e786ea2e0b95b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9587cfce185cc109044db4402b017549088a0a2264dd1eecf540889ed5e1d8b2"
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

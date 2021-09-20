class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.28.0.tar.gz"
  sha256 "0dd7314cd5c37c8184991d6834dc8a01c1d2f399e76b365a788054c2c5d53115"
  license "Apache-2.0"
  revision 1
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "db7c337bba004b903f09e9ace4f24b1ac8ca4ae44b3a9abe7e633ef840da98f2"
    sha256 cellar: :any_skip_relocation, big_sur:       "0d3f3b7bec485403510b01db991a64ac023c532e8f4d0b47f0078ff93bf911a5"
    sha256 cellar: :any_skip_relocation, catalina:      "3ae5892ab470e8a9d2f6a636f43d01079b8e2bb47583714385c8fd79cb99c900"
    sha256 cellar: :any_skip_relocation, mojave:        "ac2c5f15da8253d7b4ad2aebe38d7802b7539345df6fac81e23688f43805e22c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d20f77233f9f7ae1e5fdc9a9bb0af023f8e9e5756ad75a7d7b1b3e1f2680390"
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

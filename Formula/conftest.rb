class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.30.1.tar.gz"
  sha256 "f0928589c16b14895275745ce3d2d7362eea989cb97df7ce5bcb67ea1cb4ea4b"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9f838c5791a60278c126b660ede641552a3680a622b3b3baa18601ffdc42c23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49ee0971a08e59619786608f34ed9215ab0581553b4aa2632065165c0a16e7ba"
    sha256 cellar: :any_skip_relocation, monterey:       "bf7186a58436241823d7c2ee19cd6d9c4e79b78f6a8c4a45af7b2deb93604bfd"
    sha256 cellar: :any_skip_relocation, big_sur:        "acf45e31258792cd982d98daaab80a02834a2f3b2d88f002865ce0a8ea7bed3d"
    sha256 cellar: :any_skip_relocation, catalina:       "c4e23863f2ad42c6e0e1ce001d674ea492441bfc608770b684fd35a7e040f48c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db388322026eb2337c41d85612884a83a6dd77b15f366ee39365832c08b81954"
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

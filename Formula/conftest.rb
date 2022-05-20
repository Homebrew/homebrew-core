class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.32.0.tar.gz"
  sha256 "7e2bd2ae486d72bbc55e3ba376336fb55df62f3453ad45fcbcff3dbe766f9925"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a024da48b5404802cb946687ad15fbb126ae4ceb36dbb9fdd75ae4716fee42bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "166e6a9ea172ba122baf149eb9190b4939876b694f61351c529b319b24b930c4"
    sha256 cellar: :any_skip_relocation, monterey:       "ce1828c5db43859fdbfe466d28793722238c8b994a17674ddbe16157d098c1a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ff762f9afc866734323a0dd06e7cfd6f8fa1694fef51888c8550eaabf2b3404"
    sha256 cellar: :any_skip_relocation, catalina:       "b81dfdba49bc4839c78b60ecf25d66b44353e5be8061e365549bfb17f10015e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac005e86f1bf75f880c67a4b1b2dba38c16b55b2422355ce3bce185ce48aaea5"
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

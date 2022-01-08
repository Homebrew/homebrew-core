class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.30.0.tar.gz"
  sha256 "666b2001214640ce87ac81086a8e04880c67842a103888328d73bcd5eaf3e7fb"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e4feedca743ab023d2a56f91caa5102945cadc1b5473fa8296ae14ec31717e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b43b6fbd0737968460a1f7af6757036551b5e3a0c51b278ba419531d098782b5"
    sha256 cellar: :any_skip_relocation, monterey:       "7b6819ec5edf1c24b91b6ee12036d7b211f01f9e33c13de2b0eb9995af32f4ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "b74178747091f0ef6fa5953a405381c7abc005e41cbc9afbafe6f532bccb5901"
    sha256 cellar: :any_skip_relocation, catalina:       "bdc856e777a0efa88104f7b311efcb74866ed25e9247fce038df671960f07856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48495f55bbfc6639781c61c910f1f6e43ed9f943117f02c6d7713447bb0d7fc4"
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

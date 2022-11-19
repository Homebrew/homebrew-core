class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.35.0.tar.gz"
  sha256 "01dc54d1a6828b87c560d71df788806f2245e28352d407f535524f6f300f8aa5"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd0c05d9142006340b0b7cb8798b2de3b52a2a6252e0016390bb8acbc7fdff20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cfe7442074ce0c1c1d2a466f336e4cfc31b54a8476180181c394f802b5d5021"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fc41cbb4d60db9dfc341e548ca6a36fd0e797cbda93160f428924d987863622"
    sha256 cellar: :any_skip_relocation, ventura:        "6d4e1dc3167ccc4e7a0603e346978d4cdf00dd100ae976acdef7d806b19646e6"
    sha256 cellar: :any_skip_relocation, monterey:       "279a52a2a1ee365e813cec2cce4eef986ab11d542f904400bbc930c70b62da84"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f242809309ee5d0893adbb87ff07c94a10da1230cbe87d8dc4aa41bea341f09"
    sha256 cellar: :any_skip_relocation, catalina:       "013770592f87a86edccbc882c749a3f1e6ba15d8988b6c14b77b58014f9bec83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e221966202e97c78dc85889b741d2070ee397e5d63c38dc49e33f6ef016adbf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")

    generate_completions_from_executable(bin/"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end

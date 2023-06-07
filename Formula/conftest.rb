class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.43.1.tar.gz"
  sha256 "d5e4ea83bd4b6093ccd53f02184b8f774ad9233300e988dc675b3b6801f2d4f8"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bfaa1864e70254dad0a011e16121cb4bc2631efe5fcb4b87d7b8a25a58aeeb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bfaa1864e70254dad0a011e16121cb4bc2631efe5fcb4b87d7b8a25a58aeeb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bfaa1864e70254dad0a011e16121cb4bc2631efe5fcb4b87d7b8a25a58aeeb6"
    sha256 cellar: :any_skip_relocation, ventura:        "77a1b6347858a636d04b92396185fb584a3e42517064675a0e5d23ff22e85dd5"
    sha256 cellar: :any_skip_relocation, monterey:       "77a1b6347858a636d04b92396185fb584a3e42517064675a0e5d23ff22e85dd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "77a1b6347858a636d04b92396185fb584a3e42517064675a0e5d23ff22e85dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e85b7e748e44646524aec7b0b2dd34075df135f479adc3854ee174cfcf898cc"
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

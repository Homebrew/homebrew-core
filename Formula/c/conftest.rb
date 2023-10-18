class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.46.0.tar.gz"
  sha256 "87728a1bc02fe63227ec90d813c36197939f3c76a6f055d5556a42d1116cdc73"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b2bca4472b281c0c4d5a83155fc3cd37e28179cd510406cd1ed4ac4b2d3fb06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c603d8629ea2c9f6c08b2b3b870c23630adbb9f03bf800a3b95de6ad6ab43536"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b0875bc1235d83d74a74850da6c5e7b270cf6b82190e37b63eec22f59494074"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2d3d023b177dfb50fdb695eac6ff037667244ae7934ff65f28fffb3291a2d94"
    sha256 cellar: :any_skip_relocation, ventura:        "1d2ff38890497f5133c307414c9bf62b85af845bdf8728637271713fb1b3f304"
    sha256 cellar: :any_skip_relocation, monterey:       "75efef618044168d44fce6fe780d6ac413d83d1d71bf15f0b88e914e7d7a934c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9f6ba3eb6cac7ffc112f72532f55084900d47da18e6ffb12b07e4c749a433e0"
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

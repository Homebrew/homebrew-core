class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.44.1.tar.gz"
  sha256 "e89cdb46deaefc374132e82056f4eaff4bb08201fcc07d75896f754b49905dc7"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "016ea61483892b9ca16bb3df52a8cdfebb7b927096cbd1daa7b08293f69a818a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "016ea61483892b9ca16bb3df52a8cdfebb7b927096cbd1daa7b08293f69a818a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "016ea61483892b9ca16bb3df52a8cdfebb7b927096cbd1daa7b08293f69a818a"
    sha256 cellar: :any_skip_relocation, ventura:        "37cb17f6f61b3d0553f7cf69eec4129597071cbc185930a04bfd2fabc29e6962"
    sha256 cellar: :any_skip_relocation, monterey:       "37cb17f6f61b3d0553f7cf69eec4129597071cbc185930a04bfd2fabc29e6962"
    sha256 cellar: :any_skip_relocation, big_sur:        "37cb17f6f61b3d0553f7cf69eec4129597071cbc185930a04bfd2fabc29e6962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eae01d3a2be5af2481eafa520d40013e961c481fbbc8fa6dc1c7dacb08734c0"
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

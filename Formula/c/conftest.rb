class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "dfb1fe557f74b13ccb307f22d5bebbbe50433c225cef317a8ec761c7f7ea37b0"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c64f5c8a968bf6ab500243b6667540a2ed3b5e2180ac3a37ccf5772caedf4d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c64f5c8a968bf6ab500243b6667540a2ed3b5e2180ac3a37ccf5772caedf4d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c64f5c8a968bf6ab500243b6667540a2ed3b5e2180ac3a37ccf5772caedf4d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "471db4756b576675f4a0a65ec595c14e833cefaca970afc7e1b493af21780e92"
    sha256 cellar: :any_skip_relocation, ventura:       "471db4756b576675f4a0a65ec595c14e833cefaca970afc7e1b493af21780e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84f2eba2ce487f5f52a63a98b2f6064bb7acc83a687878927752af8ced89ed5f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/open-policy-agent/conftest/internal/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system bin/"conftest", "verify", "-p", "test.rego"
  end
end

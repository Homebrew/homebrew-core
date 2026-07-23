class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.68.2.tar.gz"
  sha256 "952ebb9e9eccc75521d0f618ab1a934c379f13ffdb000f0fa8b698f00eaf4601"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a509a800966752646d9cdfd8928d30bb6a1d1c66473ce3cd9c68e72b32b7918"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a509a800966752646d9cdfd8928d30bb6a1d1c66473ce3cd9c68e72b32b7918"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a509a800966752646d9cdfd8928d30bb6a1d1c66473ce3cd9c68e72b32b7918"
    sha256 cellar: :any_skip_relocation, sonoma:        "59300fe25b9f5c8072fe02e7774bfa9bbc9c7747cfaa2d1b422e8b72fd62ed8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af118a9076b99ccbde937a74e3592c22f6c2e5798b4d0497b93d5d73fd0b8bb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "410e041060923ab2ec2e4f7dda61d7c931a52a040774c207041c0eca5dc963c4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/open-policy-agent/conftest/internal/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"conftest", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system bin/"conftest", "verify", "-p", "test.rego"
  end
end

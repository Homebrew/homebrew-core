class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/refs/tags/v0.68.0.tar.gz"
  sha256 "ef80ec47bf06da04c4be10fa7b506b241483ddcda76930b9cb34f79377a6d224"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8db267e3de2ed4f28252cf082adde13460853e67804b4359b8164d2ba4917996"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8db267e3de2ed4f28252cf082adde13460853e67804b4359b8164d2ba4917996"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8db267e3de2ed4f28252cf082adde13460853e67804b4359b8164d2ba4917996"
    sha256 cellar: :any_skip_relocation, sonoma:        "046a35c44c0e96e7ea6091578bceb86d2edf05e3c28ee1e6d65d6b8ddadda011"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f06cbdc1eff09884796a0f909e6958db34ffc95fd3615827c1628118209084ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ba9c0e8ab5bcbb3d1f7f651df886252ab2b63cd31b9825372737f48741d3007"
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

class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.25.0.tar.gz"
  sha256 "9319f9cbd747099565ce6aad70708da0e50584eab295b7f036ea4b076e168fcb"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8be3d3469f6843eebaf9e196abb975a14a7e62f584e16bb983f3d9d443e02bc1"
    sha256 cellar: :any_skip_relocation, big_sur:       "b9432b0b64f963d09698455df0df322d968043e5fdf4a72b4ecd8a1172616a5f"
    sha256 cellar: :any_skip_relocation, catalina:      "4a7dc940ec6bfd8910edc391264288b757ac498026d30e2e02dca19bb2a14fc0"
    sha256 cellar: :any_skip_relocation, mojave:        "c13321d7e91dc00669c574cf3255efe47ad17735e6753a80979e51ffd8b359d3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end

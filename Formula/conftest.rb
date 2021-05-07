class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.25.0.tar.gz"
  sha256 "9319f9cbd747099565ce6aad70708da0e50584eab295b7f036ea4b076e168fcb"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b2b07a7e5648f868c9f154169b0c7d0f149f7ce0443a5f32ce1b679eab7f4672"
    sha256 cellar: :any_skip_relocation, big_sur:       "604ffe150b31007d51cbc79a44229c93dcbc9849246da188b7e84b9ef9186917"
    sha256 cellar: :any_skip_relocation, catalina:      "5a1c9dc637d851845667c1f57953b2f4c41e2c05501413e7526e7440112d0a6a"
    sha256 cellar: :any_skip_relocation, mojave:        "41f211bcc4aef7dcdeeb1a7ea4c3f1d33258ceec3bcb2eb8a278b1e0866b4532"
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

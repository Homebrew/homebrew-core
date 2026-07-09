class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.36.2.tar.gz"
  sha256 "c8188b81c19d60952e988aebca0779a4f5bd34ee41ea8949b2fec15d2e3ee101"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acdb40136da6814bd5173c1dc24a04a8c255cc1d58e7ee14b575ccf6ea1a829f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acdb40136da6814bd5173c1dc24a04a8c255cc1d58e7ee14b575ccf6ea1a829f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acdb40136da6814bd5173c1dc24a04a8c255cc1d58e7ee14b575ccf6ea1a829f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9a506973b4e1d6a5655fafda012f4cfe578fafe2732ea5c7d0a26a400fbef2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56b93bddca335925ff86171000a0d79255fc4106e7d503199e046a1ae954131f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32304d06093b0b2770a05b825121af4e057090d11c07a4c9a586b09800ca2bc0"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-oidc_login")

    generate_completions_from_executable(bin/"kubectl-oidc_login", shell_parameter_format: :cobra)
  end

  test do
    version_output = shell_output("#{bin}/kubectl-oidc_login --version")
    assert_match version.to_s, version_output

    assert_equal version_output, shell_output("kubectl oidc-login --version")

    # Connect to non-existant OIDC endpoint
    get_token_output = shell_output("kubectl oidc-login get-token " \
                                    "--oidc-issuer-url=https://fake.domain.invalid/ " \
                                    "--oidc-client-id=test-invalid" \
                                    "--skip-open-browser 2>&1 || :")
    assert_match "fake.domain.invalid/.well-known/openid-configuration", get_token_output
    assert_match "no such host", get_token_output

    # Connect to real test OIDC endpoint, with invalid client-id
    # This is a public test server: https://openidconnect.net
    get_token_output = shell_output("kubectl oidc-login get-token " \
                                    "--oidc-issuer-url=https://samples.auth0.com/ " \
                                    "--oidc-client-id=test-invalid " \
                                    "--skip-open-browser --authentication-timeout-sec 1 2>&1 || :")
    assert_match "Please visit the following URL in your browser: http://localhost", get_token_output
    assert_match "authorization error: context deadline exceeded", get_token_output
  end
end

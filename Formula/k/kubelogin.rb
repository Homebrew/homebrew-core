class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.36.3.tar.gz"
  sha256 "b8ef89b66887b9da17e2e585b906021c436a117354aa2758a83e08412eeb8ede"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2ebc21dcb9ea13139e4ef305af8eeb024edf6880e81ccaa4c0d51557b6a5335"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2ebc21dcb9ea13139e4ef305af8eeb024edf6880e81ccaa4c0d51557b6a5335"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2ebc21dcb9ea13139e4ef305af8eeb024edf6880e81ccaa4c0d51557b6a5335"
    sha256 cellar: :any_skip_relocation, sonoma:        "39d8d47fc8400c4f11b613bf7670c19ab1630fc5f9f0f1ecec949e5231f2c9ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4bc01589c3a45a05d747d2524f103a4c8ae1386cdd494d582cb614cc7a016b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "033ec8de4f686e7290a1c45967fa81e2ef4f97d592fa67bc39ec63ea61fbca09"
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

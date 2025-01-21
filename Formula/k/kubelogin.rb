class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "0309afc1c15cac8046d6f9b04ebed5cffe0d20f6b58e31de479ddf5a2f5f0ce8"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25c132b84fa44e929ffdeffe81de28f2b866014712e83da8f69a094db1f1f4b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25c132b84fa44e929ffdeffe81de28f2b866014712e83da8f69a094db1f1f4b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25c132b84fa44e929ffdeffe81de28f2b866014712e83da8f69a094db1f1f4b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e926b4d191d4e0c7a97537da4a44874af6d5dfe887e7cc16a1cee4069534996c"
    sha256 cellar: :any_skip_relocation, ventura:       "e926b4d191d4e0c7a97537da4a44874af6d5dfe887e7cc16a1cee4069534996c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "371aaea650a40c78e51a0cc16caf1d4efdfe7684a267a8700a5b46ba79c9c61f"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-oidc_login")

    generate_completions_from_executable(bin/"kubectl-oidc_login", "completion")
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

class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "7569969b178f9f771a8e0238afb41665dcfd3250e30865aac08e0887bebf3b76"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "872e75021d159daa73ae002498608025dae2608f2594a45489586d31e5f1504b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "872e75021d159daa73ae002498608025dae2608f2594a45489586d31e5f1504b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "872e75021d159daa73ae002498608025dae2608f2594a45489586d31e5f1504b"
    sha256 cellar: :any_skip_relocation, sonoma:        "83eda92bb14896ca7f41448dcdd482f36028b07adb63febb4b8616a033e99414"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59c544195c6f46111fc14a033affe11008c7fdaefbe149684b20912fac6a62eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47f545eea4c470f69e8afd8726c7153b80c0db31e524eaab30990b41421d33af"
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

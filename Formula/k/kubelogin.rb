class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.32.3.tar.gz"
  sha256 "19a6627825affe992e60164e8ad76625262cc1670d1ffbf56ed3dcf48da1c40f"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62f2b1572b2d47d3bbb53a1fc9b7d5e5f648362f83dfc7ce5f118e5efb2776bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62f2b1572b2d47d3bbb53a1fc9b7d5e5f648362f83dfc7ce5f118e5efb2776bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62f2b1572b2d47d3bbb53a1fc9b7d5e5f648362f83dfc7ce5f118e5efb2776bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d74f82cac1459425870dfd778ece8816e30892407af04cfb86d2f90e881990f5"
    sha256 cellar: :any_skip_relocation, ventura:       "d74f82cac1459425870dfd778ece8816e30892407af04cfb86d2f90e881990f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bd62707d45b8c0af101ef57778557f19d8afe2fc65bdea9fcb73ac13d2c67cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "750b249b73c7d778fdd6fcf7fdcdae5c4e63270b4a2d78ed94177c811c659749"
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

class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.32.4.tar.gz"
  sha256 "3d3f7bb52eba25885a760b51ea517514e77ab0c4f6b9fa796be3b9abc1268ded"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6745733c6cbb50b53d96798bbbd038454486557fc0db3527238ea7ea76dd1d1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6745733c6cbb50b53d96798bbbd038454486557fc0db3527238ea7ea76dd1d1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6745733c6cbb50b53d96798bbbd038454486557fc0db3527238ea7ea76dd1d1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca38437fbdabe9f4bbb434e7b2d84ad9db3790305549d2fbc2ac9ce0c84a616f"
    sha256 cellar: :any_skip_relocation, ventura:       "ca38437fbdabe9f4bbb434e7b2d84ad9db3790305549d2fbc2ac9ce0c84a616f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25fa0e56eb6d2b9a4c3a4794b5a1947caf5cebb348463d5ecb03393cace40bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc48a0537d00c6f18c8c50f335716436d536369dd203322316b4fd1d099c2382"
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

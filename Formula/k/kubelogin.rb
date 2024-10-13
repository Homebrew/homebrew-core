class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.30.1.tar.gz"
  sha256 "3a9f71a1b0192c5fee6656bbe5190579756ce1d5fcde0446c28d985039182068"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0904aac4d1114c91a22ad60f5636c49cb0749bcd2642cf6de6a7c80a4b86600"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0904aac4d1114c91a22ad60f5636c49cb0749bcd2642cf6de6a7c80a4b86600"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0904aac4d1114c91a22ad60f5636c49cb0749bcd2642cf6de6a7c80a4b86600"
    sha256 cellar: :any_skip_relocation, sonoma:        "79a25d589eb0d14d62486b695e4967439c9b1251a799aa4ab225962ea6338138"
    sha256 cellar: :any_skip_relocation, ventura:       "79a25d589eb0d14d62486b695e4967439c9b1251a799aa4ab225962ea6338138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1067dea64447c01fd83bb764147fd2cbf0852f754e2301ff1d7bc7012e43207"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-oidc_login")
  end

  test do
    version_output = shell_output("#{bin}/kubectl-oidc_login --version")
    assert_match version.to_s, version_output

    assert_equal shell_output("kubectl oidc-login --version"), version_output

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

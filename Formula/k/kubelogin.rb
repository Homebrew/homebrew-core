class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "549800acb06b54ec8ae1c768dfd583da262d485d0adad2c1893843067f087e7f"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "764973f37e431c74f7086800f173f7ea3a14423fc0dfa3307286d6c7a035f49c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28defe4fdc6cf1664ff22e9e1956a4d945fc60a8000b982a3b30156e214aa091"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a662416ea97e6ca3ce2829c5a9facdb4f4494c5bd999d7b05345624e62d49eb8"
    sha256 cellar: :any_skip_relocation, sonoma:         "98f59153fdf6f17a1d77495a636e74010ce4ca954b85eb8819a89db4bff54607"
    sha256 cellar: :any_skip_relocation, ventura:        "2df9ade5f9a9365a573fde9629bd39008d68a1e0c2de6691a999d350b0948aa4"
    sha256 cellar: :any_skip_relocation, monterey:       "03f07e951cc281cee46702fbdbce6a58bf566b79ce20da5b3439760db2b4391a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "926f87f447d807de00235dccc5d332785388f6d544a18b82768902bbf14bffbd"
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

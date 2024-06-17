class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "4a4b721c08383477618af26d388597eb7040d6609ac7876494b1337966d30cbb"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa11418683ad5d6f3595df17ba10405063df3cfce7c0407a9d5a427f2abe7888"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e6d08cb59c93726eae8f7ea0f50745ccb45417be6d5700f93b75c639fa73962"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09482e9280046c431afedbd8263cc027c9b7e895e5d97f2d2bc1f580ed5e5066"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbba21ad246ff264e792dbb54d7e0f33d5fd3a5745579c2f87199316a2b003a0"
    sha256 cellar: :any_skip_relocation, ventura:        "cc7fe71f0547716bfbba1f5fd0afa20d0f6be6711956d01472747bf080414b6e"
    sha256 cellar: :any_skip_relocation, monterey:       "43f6f0d0610b3274c057149a9ada7b9f0a7ce5499d6a4353abaaa4ad8da75e71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d4ed646597056633c7524f800d84e7d1ba86fcbec13309c3001440fa4d72d13"
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

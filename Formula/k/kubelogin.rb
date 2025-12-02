class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "bf73e9d11c3eec408191532d25a25aae37d588f30c256a6fa6ed2029777a0ee4"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87765478639ae16900b13c59943e44fe8a02fecfd03dc366e9efb94b925599e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87765478639ae16900b13c59943e44fe8a02fecfd03dc366e9efb94b925599e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87765478639ae16900b13c59943e44fe8a02fecfd03dc366e9efb94b925599e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "80afa3e74c9aa30e2b702b28e996b1c7d7ac810c9dfb2275c4defc7d2007bd42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63797ab8d7a8ddf4b624bdf63eaece04746a1a595f6f5933f92d7d7f8b9db9be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "555511434ab918d60437e3ccfeeaed8a0d7a5a861977da7ffef1ac2cb7b5f7f8"
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

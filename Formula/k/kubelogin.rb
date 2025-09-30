class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "9ecdd5e01ce8071a9ba2766608f57ad0131f1a5521a54cf70063d988c3fddc28"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8e9af56ca66dfe69d3a8f848254789aa4d0111dae7a3ea708f5b65bf24bb501"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a683850d01415fb9443422e3bf385a8de03a84f017540f66eb945845d8df3f50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a683850d01415fb9443422e3bf385a8de03a84f017540f66eb945845d8df3f50"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a683850d01415fb9443422e3bf385a8de03a84f017540f66eb945845d8df3f50"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3c88b1c5c4377f5911afe8adfc59f0c64ad2882d2ffb17926a7dad36423ee1d"
    sha256 cellar: :any_skip_relocation, ventura:       "c3c88b1c5c4377f5911afe8adfc59f0c64ad2882d2ffb17926a7dad36423ee1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70fe8c51c543d857bf86a0a6ab04a966aef4769ebddfc5abd8937e7ea1d2b9f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e747ff9bf08105204b08770110c9589a2112a6405e7056d6b2e84832a037d878"
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

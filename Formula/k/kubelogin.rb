class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.34.2.tar.gz"
  sha256 "b985941581606398bc359d37f35c27bfc70e996eb6048f036c152447a4bb7cf6"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c3b7a83ad62e5a8eb9ad8ba95d47e6b8a4a85ef2a370cf875041c040f4600dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c3b7a83ad62e5a8eb9ad8ba95d47e6b8a4a85ef2a370cf875041c040f4600dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c3b7a83ad62e5a8eb9ad8ba95d47e6b8a4a85ef2a370cf875041c040f4600dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "29df1be4453fb84333c25933d5d3ae4bc7670587c780ee2ccf1a6ca1c8e4dc87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e01af71a1423d1418c70f191b0ded74578b6f9cd618d8526068c419a866125c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98b39064f85b5e1ae3afbd99547b007896613136b5d6623a67b319338ebd95ee"
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

class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.32.2.tar.gz"
  sha256 "8ea8abeb811d0c6b243a56c9eb19bea8c8e587fe4899d58df83893aed39e20be"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97b5ed0e47cfa4b2689e001ade7a7e787f2d732d82d5e84e0b1beb30ff3a464c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97b5ed0e47cfa4b2689e001ade7a7e787f2d732d82d5e84e0b1beb30ff3a464c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97b5ed0e47cfa4b2689e001ade7a7e787f2d732d82d5e84e0b1beb30ff3a464c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a72a852b608058253b8fd82494841a14c327dcd292b7d8452ce02ec5fde753cc"
    sha256 cellar: :any_skip_relocation, ventura:       "a72a852b608058253b8fd82494841a14c327dcd292b7d8452ce02ec5fde753cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86a3bd21e83b997581482fcda3f6eea32c82ebad9a7992a35987d44e3dc748f3"
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

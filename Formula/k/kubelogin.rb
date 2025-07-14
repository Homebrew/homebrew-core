class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "bc9d05a9771d146de34b584755d1446de53f820eee283614a925e9edc441d08c"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aec0fe3ed7f5b6122b4c1ffc2b9cb5efd3ef0b445876be6a708609213cfdb3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aec0fe3ed7f5b6122b4c1ffc2b9cb5efd3ef0b445876be6a708609213cfdb3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9aec0fe3ed7f5b6122b4c1ffc2b9cb5efd3ef0b445876be6a708609213cfdb3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "47e9911b2ad9adb201b6816401566d82276640854e3a7bed64091be83a21c1e6"
    sha256 cellar: :any_skip_relocation, ventura:       "47e9911b2ad9adb201b6816401566d82276640854e3a7bed64091be83a21c1e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf636982cb0e8c9cb8f51c76cc3760fa1bd5c199c70f1021c91818631f94103b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa52a5459f915262d56e74491f3f18a2e809130f9ffbf647d756e8168fb3b2b4"
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

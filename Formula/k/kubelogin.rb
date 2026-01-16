class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.35.2.tar.gz"
  sha256 "6becc80ae7071b7b2995f8b1f5056fa4a844c3a36ae5ef95f3cf28d5e1ec0396"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2107da0057ab25ba7d470203308772c30e0a68f6ac6670e9629b164e6bc30d48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2107da0057ab25ba7d470203308772c30e0a68f6ac6670e9629b164e6bc30d48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2107da0057ab25ba7d470203308772c30e0a68f6ac6670e9629b164e6bc30d48"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cddeabd1f4440a3860cd70ace522877613a11d982318db167bf33db75ebae08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f72ac35211fcfbf999f1d9e5d564414a15aeafc4f8f9f1f85f2b71342c5eb0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a0ea6c496eddc573fa2e492048ddd50f65545c9420092715e9a8c6fededb718"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-oidc_login")

    generate_completions_from_executable(bin/"kubectl-oidc_login", shell_parameter_format: :cobra)
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

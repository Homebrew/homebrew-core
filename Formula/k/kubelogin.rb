class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.36.4.tar.gz"
  sha256 "ddae6975006895791d0bbf8464f228b3911f697b869446fdf1b8233c12c30544"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "94a45b967a6e111e8ee741a456262fab855e2520b25c2b6dce7fcdb7edff48f1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "94a45b967a6e111e8ee741a456262fab855e2520b25c2b6dce7fcdb7edff48f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "94a45b967a6e111e8ee741a456262fab855e2520b25c2b6dce7fcdb7edff48f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "94a45b967a6e111e8ee741a456262fab855e2520b25c2b6dce7fcdb7edff48f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "51c27a653bd82c93db98d931b05324b3f48cfd10e8d982d633f9eac3d7deb99e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2cc8ac23815afccdc9291068c23592b3a6a94a61d29a7a08873e763846af83a5"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  # `test do` block performs OIDC discovery against samples.auth0.com
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-X main.version=#{version}"
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

class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "ef351a7231d8bf1f4fccec35598cb0b01d007ff09cb902446f3f53b474c6319c"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3721c8faab701240d8ab99a4e2578b11bf8ba6e47457879c380eeb12859c3fd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3721c8faab701240d8ab99a4e2578b11bf8ba6e47457879c380eeb12859c3fd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3721c8faab701240d8ab99a4e2578b11bf8ba6e47457879c380eeb12859c3fd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "32862e1f14279b7db00ff5923b1212c3d9f37000c2e45ff172f755a22630f0ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eacd220d36bff26405593d3459d130bf7fbb002efcf8c3a2358e3b33daff7ca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96cdeec7876e21ae7cbbbee7f3f2ed51c8878917aa481c41f6e748ee4e75ec6e"
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

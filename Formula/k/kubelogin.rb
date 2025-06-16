class Kubelogin < Formula
  desc "OpenID Connect authentication plugin for kubectl"
  homepage "https://github.com/int128/kubelogin"
  url "https://github.com/int128/kubelogin/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "41016c118281fe7e8686c2bcf034f879d1b5dc49bc9eb0900ddce1d2d259290d"
  license "Apache-2.0"
  head "https://github.com/int128/kubelogin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f023f71bed4a4030c61f836726cfa751b7acad7a9b2d18dc4cbf1f88ab94d2a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f023f71bed4a4030c61f836726cfa751b7acad7a9b2d18dc4cbf1f88ab94d2a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f023f71bed4a4030c61f836726cfa751b7acad7a9b2d18dc4cbf1f88ab94d2a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8aa08bbc17eb4209b7cde1fd40bc7056b4a300bf39e72f6126440b4068d85f9c"
    sha256 cellar: :any_skip_relocation, ventura:       "8aa08bbc17eb4209b7cde1fd40bc7056b4a300bf39e72f6126440b4068d85f9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0feb10f33b936529d4aa62da89dbe6d88c7f9032a10a6446a0e41c27fbd4a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fce98937cb1efb008ea411bfc750f7ac94784341090a7ed1e19f3e077d675100"
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

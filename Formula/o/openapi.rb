class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "0b3bca16d6cb1b678d513e97d7298a10aaf93ddf16508c254b26b14039a3397a"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb4e3a7ee8dc2928029ae62a9d4e99102366a108a5a2537799c563ea9053a9c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb4e3a7ee8dc2928029ae62a9d4e99102366a108a5a2537799c563ea9053a9c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb4e3a7ee8dc2928029ae62a9d4e99102366a108a5a2537799c563ea9053a9c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1372eb87ef7cb67cf38fdf9faace46bf551401f1a308c86fb32aa1d8448b169b"
    sha256 cellar: :any,                 x86_64_linux:      "1dead32fc7fc16bfbf862ed609fd6524889b6d08f0d2128c2a01b37c7ee4ab2b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/openapi"

    generate_completions_from_executable(bin/"openapi", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end

class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "7fc3a2d7bc02a6b51631b4826da841c46b7235218847df33c761aa43208de346"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1addc2d2f54522553f8e25ba96e5b196290d8c6418d90fce41daac4510fbefda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1addc2d2f54522553f8e25ba96e5b196290d8c6418d90fce41daac4510fbefda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1addc2d2f54522553f8e25ba96e5b196290d8c6418d90fce41daac4510fbefda"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d4af7367d373b8944df8089d6b17542cb11621813cfdf9ae36cd29e72a1c1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfe76acea35717d7cd1ada23c676f3a7764c368b752e07bc22d0aa8aa9dd847b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openapi"

    generate_completions_from_executable(bin/"openapi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end

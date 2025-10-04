class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "c37d920af829735a68d5ff46f56bf7304f581094a7e7f5fb7b023546685e0254"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c943043f2a9bbef2840aaf89603a255b34e426ae1c0e53e299efb676cb75289"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c943043f2a9bbef2840aaf89603a255b34e426ae1c0e53e299efb676cb75289"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c943043f2a9bbef2840aaf89603a255b34e426ae1c0e53e299efb676cb75289"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f2ac8a521fc4d32a3ad89d376e61dae9afe82a7dd16a95fb85db553f5fb3c8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48e20752955ef290092756e81115270d12fcbe6e8dc7c26447ee66ba34bee8bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acbae4adf157bcfb26b765f7588ddaafc63fac580081d37e37409b09d2f1c2d2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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

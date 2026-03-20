class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "c1088a68b634ae3f3dd10a78368eea54bd03c57426c0c2752e16a05d2920281e"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bdcc5aca6077678fad9d7c3ed5132d4963fa9461971e882d163d502be017b4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bdcc5aca6077678fad9d7c3ed5132d4963fa9461971e882d163d502be017b4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bdcc5aca6077678fad9d7c3ed5132d4963fa9461971e882d163d502be017b4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d6b1dadfa2e34d68939ddbad5ad532ef392ce01e32da7129f615eeff8a4406e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d27da8204db1a1ec6a8dc43a709091f30a817c0c4103bce715362a981821bae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d80043f845dffbe5f6e8223fbae6be31a45e47c81e37648317930f74c9b9333b"
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

    generate_completions_from_executable(bin/"openapi", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end

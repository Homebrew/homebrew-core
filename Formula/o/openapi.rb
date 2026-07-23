class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "0122386f879814bd3ac4d461b8205ed351b5ec1afb9078b71da8799a94c41324"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d848625b03ff4cb7c2cf2eedc73031cb624733384ec5d0f90693f6515198ada8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d848625b03ff4cb7c2cf2eedc73031cb624733384ec5d0f90693f6515198ada8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d848625b03ff4cb7c2cf2eedc73031cb624733384ec5d0f90693f6515198ada8"
    sha256 cellar: :any_skip_relocation, sonoma:        "828327ace6d7e308d38d9aa74a5550eddc91adcff6db3a6e226017e4de04efbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62959ac987bf49b8542dad8e47269b560d4abbb72df2995f90b9fd19dbe44276"
    sha256 cellar: :any,                 x86_64_linux:  "606cb98083a9f0aeb0a4c1458ef1f22540c6c0897671017d79c247670cc2d9f9"
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

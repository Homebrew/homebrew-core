class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "b17ba7de181cc135d2318a6c06edec3b8e8b23e8d08fb30f419303b1310092a6"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a342056d8415028845a95fc46c4ecade737671be3af45fed8ea1f3324392f67d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a342056d8415028845a95fc46c4ecade737671be3af45fed8ea1f3324392f67d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a342056d8415028845a95fc46c4ecade737671be3af45fed8ea1f3324392f67d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae15580ce0295e9046903e23a22095e7eb2b38320757b80a950f520e02cb6f0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7292abbcbba838f8291a571412ed4b15879cbe6bd53311c8a4f3dfcbac2f6ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51577816bcc15dea5901f85d1ba23ad29982c7e075e9d085af1f0776e915b9b1"
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

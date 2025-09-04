class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "21623e55af418462208d66434ef89bd4b1249b9af7f7f64c4316e62316f37e15"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "deb7c8bc4186de33b57d43dccbd4eeefe3d9325abc619e07360b425f333085c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "deb7c8bc4186de33b57d43dccbd4eeefe3d9325abc619e07360b425f333085c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "deb7c8bc4186de33b57d43dccbd4eeefe3d9325abc619e07360b425f333085c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6194c737fb2b51325dd1047fbe1d547065200d04625d37d208bd23712394436c"
    sha256 cellar: :any_skip_relocation, ventura:       "6194c737fb2b51325dd1047fbe1d547065200d04625d37d208bd23712394436c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3627deb82e6df0faa6cbc4649a0890eb97cac46168840407e581876b250e7e66"
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

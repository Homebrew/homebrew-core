class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "0bf169a03eb71ca55b556d2edb45b7ef30f1d41351a65cc74f6e5a61d163045d"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1bea1db7467cdc13f152fd2b9e93ca2b9ac7a9934b14b7cf3b5b6f1017f8990"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1bea1db7467cdc13f152fd2b9e93ca2b9ac7a9934b14b7cf3b5b6f1017f8990"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1bea1db7467cdc13f152fd2b9e93ca2b9ac7a9934b14b7cf3b5b6f1017f8990"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6aa828c233420584c3a2c27aa54d217bad8fce53cbf7f3bb62e32b518a2862b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "631ea240f00c942552472345121bf9b04049c2d34f08549256d5432544ad165c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "891c9d8410d8b49cc8b22c9046d195c1e229cda9b9b61ce78033570908b6bfe7"
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

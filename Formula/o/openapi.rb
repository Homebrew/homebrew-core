class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://www.speakeasy.com"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "be475890b4c86448225f81ddade8870329db16a6f2fd9164361fd6d55968860c"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    manifest_sha256 "3470c293d6f78fb1ceca71d3dea7440bc53b261c9a4c75a6fe5f2c3ce8dbabc6"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "302db710e32fb3f346dba707131dbcc1454ff35edd1ef9a250ce4eb0247fdf9b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "302db710e32fb3f346dba707131dbcc1454ff35edd1ef9a250ce4eb0247fdf9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "302db710e32fb3f346dba707131dbcc1454ff35edd1ef9a250ce4eb0247fdf9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b1b1697de16f582c4c4cdde8463327e1a05d4242a9dac51e20a499cb0faa3fef"
    sha256 cellar: :any,                 x86_64_linux:      "9d1820fae7c28f1a0234487e9716c788c6d1c330373f150ce8871f59bb1e1cac"
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

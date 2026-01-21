class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "105e379f1a986d7cbd63e0b9d15084f0183c422a25ff99c83f0dbb51037abd39"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75a3a20f5d15d8d7d479ce4d0911e78b88f9a52b6a34a36ddc3dc52b661580c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75a3a20f5d15d8d7d479ce4d0911e78b88f9a52b6a34a36ddc3dc52b661580c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75a3a20f5d15d8d7d479ce4d0911e78b88f9a52b6a34a36ddc3dc52b661580c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "362da378120a2ea865b5a322517fa0c82c360f6b833b16b22c9060a7b75010ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5441ae1f5d125b2f7fd400f58f76b89d5d57a45b6d02f888e200da0d7fb15c78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6560d568628a4290c0d60a53e07e55474ce3d38225950eb97789c0fca371f276"
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

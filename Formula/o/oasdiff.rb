class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "9e000211f5a9561ffeb6ab078e02177349f1f262a69f0619d9b0a507cc73498e"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2492fce9f9c04e2a63065f318202b8096faa8fe2d10137eaa440a1fce32d57a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2492fce9f9c04e2a63065f318202b8096faa8fe2d10137eaa440a1fce32d57a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2492fce9f9c04e2a63065f318202b8096faa8fe2d10137eaa440a1fce32d57a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e30d27b8221cac705df90e3d5da2a044b8ddb646f5b294319c6fecb88cc3b47"
    sha256 cellar: :any_skip_relocation, ventura:       "1e30d27b8221cac705df90e3d5da2a044b8ddb646f5b294319c6fecb88cc3b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79814fa3454417be7ebf2da31ebf0f627850637a0c8192739f5dd8dc02b45d86"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/oasdiff/oasdiff/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"oasdiff", "completion")
  end

  test do
    resource "homebrew-openapi-test1.yaml" do
      url "https://raw.githubusercontent.com/oasdiff/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test1.yaml"
      sha256 "f98cd3dc42c7d7a61c1056fa5a1bd3419b776758546cf932b03324c6c1878818"
    end

    resource "homebrew-openapi-test5.yaml" do
      url "https://raw.githubusercontent.com/oasdiff/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test5.yaml"
      sha256 "07e872b876df5afdc1933c2eca9ee18262aeab941dc5222c0ae58363d9eec567"
    end

    testpath.install resource("homebrew-openapi-test1.yaml")
    testpath.install resource("homebrew-openapi-test5.yaml")

    expected = "11 changes: 3 error, 2 warning, 6 info"
    assert_match expected, shell_output("#{bin}/oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}/oasdiff --version")
  end
end

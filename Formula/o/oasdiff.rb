class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "f4cf977e6a00bdc85b380a60d11108985f18916039047489310ddb5eedd7a38e"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c49d1f5b795be5cc72b779b818d70a54eba9d3b3d8e0cca027781fb3befa39a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c49d1f5b795be5cc72b779b818d70a54eba9d3b3d8e0cca027781fb3befa39a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c49d1f5b795be5cc72b779b818d70a54eba9d3b3d8e0cca027781fb3befa39a"
    sha256 cellar: :any_skip_relocation, sonoma:        "277ba936abd3a27ea79c8555dd75ead3621d08bccbfacdfee7472d554f1be053"
    sha256 cellar: :any_skip_relocation, ventura:       "277ba936abd3a27ea79c8555dd75ead3621d08bccbfacdfee7472d554f1be053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e56ba33261cfcc5dac7360b401fcdf0f7ea9fa3d6705b51f6ae1fefacaa760d8"
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

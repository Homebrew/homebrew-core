class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/Tufin/oasdiff/archive/refs/tags/v1.10.28.tar.gz"
  sha256 "8eefab2ab3b0ea0a4a6b25dbc6ee85e7649885e6761505dd518ac246ed3fcb6e"
  license "Apache-2.0"
  head "https://github.com/Tufin/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36e27df9700bf2e119eaf5b1b77ad5e40081aa1ad6b276d28fdb32d1d1d8d390"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36e27df9700bf2e119eaf5b1b77ad5e40081aa1ad6b276d28fdb32d1d1d8d390"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36e27df9700bf2e119eaf5b1b77ad5e40081aa1ad6b276d28fdb32d1d1d8d390"
    sha256 cellar: :any_skip_relocation, sonoma:        "a01dbfd8634244409d275a9efd4e042fc6aad7d208deb5863759140901cf2dd8"
    sha256 cellar: :any_skip_relocation, ventura:       "a01dbfd8634244409d275a9efd4e042fc6aad7d208deb5863759140901cf2dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9caa39e9feacbf3e99305dfe4d8df43b716c5d947539375441b6382bd248ed7d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tufin/oasdiff/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"oasdiff", "completion")
  end

  test do
    resource "homebrew-openapi-test1.yaml" do
      url "https://raw.githubusercontent.com/Tufin/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test1.yaml"
      sha256 "f98cd3dc42c7d7a61c1056fa5a1bd3419b776758546cf932b03324c6c1878818"
    end

    resource "homebrew-openapi-test5.yaml" do
      url "https://raw.githubusercontent.com/Tufin/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test5.yaml"
      sha256 "07e872b876df5afdc1933c2eca9ee18262aeab941dc5222c0ae58363d9eec567"
    end

    testpath.install resource("homebrew-openapi-test1.yaml")
    testpath.install resource("homebrew-openapi-test5.yaml")

    expected = "11 changes: 3 error, 2 warning, 6 info"
    assert_match expected, shell_output("#{bin}/oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}/oasdiff --version")
  end
end

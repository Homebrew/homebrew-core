class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "9cd56674a6920aac77901c0009156184214d0269c7fa359fb488c1da1633c4cf"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2a6e9a3a52208424d83eba14e42f1b68034e2f9ca67c191ce5ed60b4085a0b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2a6e9a3a52208424d83eba14e42f1b68034e2f9ca67c191ce5ed60b4085a0b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2a6e9a3a52208424d83eba14e42f1b68034e2f9ca67c191ce5ed60b4085a0b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "faef05fe2d12f4261a76d63965f2058aa2393269b490338071484444bfe6717c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecf5a02ea15c14da761dbcc3fefd639ecde140daa4edb15d10adaf14f119c7b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a75c724d574a146a7265ee0fb54990d7f62897e6d8bab190daf01cdad483d12"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/oasdiff/oasdiff/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"oasdiff", shell_parameter_format: :cobra)
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

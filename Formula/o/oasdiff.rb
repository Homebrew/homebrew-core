class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "6d1ca07fee91c359da04b9094b9d29da5e8cf40466f94f1cefc0d437a5b2fb93"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bba67bf700c1d9260038adaac821f9afe0f38849f2981c40ab59f936ae9ca79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bba67bf700c1d9260038adaac821f9afe0f38849f2981c40ab59f936ae9ca79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bba67bf700c1d9260038adaac821f9afe0f38849f2981c40ab59f936ae9ca79"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7e2d5179806cad888d9b6286482be9879131806906b41eed82beea35ecce487"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fb85198af78bc55e38af9d08b1ed97e7b9dbfc2911de1a7d80ecb988e933260"
    sha256 cellar: :any,                 x86_64_linux:  "fa8ecbda59b4ab90424494b1c458cb5a0d4850036251563d47eb1e35ecbe479a"
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

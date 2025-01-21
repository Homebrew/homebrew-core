class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/Tufin/oasdiff/archive/refs/tags/v1.10.27.tar.gz"
  sha256 "e38f326490c62eca6924208865df3516c0f5d0d22df8be2f78e7e918da7980f3"
  license "Apache-2.0"
  head "https://github.com/Tufin/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9451f0c14981c9db99d5ecad79df70e8987428e1abd0fe3f5318bbaf03932060"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9451f0c14981c9db99d5ecad79df70e8987428e1abd0fe3f5318bbaf03932060"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9451f0c14981c9db99d5ecad79df70e8987428e1abd0fe3f5318bbaf03932060"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe7fff2691f30fbd004a826cb4e9091ca75f21179bac3a99a6f393bb5d49088d"
    sha256 cellar: :any_skip_relocation, ventura:       "fe7fff2691f30fbd004a826cb4e9091ca75f21179bac3a99a6f393bb5d49088d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcddebeb971e0940c50f1c146544028aff38f16629c51448a896615e5c96bcb0"
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

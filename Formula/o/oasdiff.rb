class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "d77b2604dcdf1656b92ea96c45604af4ad3541b1a5be03f3830b1fa2a273f728"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c2a19ded6f585bb032f3033c2dcaa66ad3a0e15b2f82a423d143a20a3f18273"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c2a19ded6f585bb032f3033c2dcaa66ad3a0e15b2f82a423d143a20a3f18273"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c2a19ded6f585bb032f3033c2dcaa66ad3a0e15b2f82a423d143a20a3f18273"
    sha256 cellar: :any_skip_relocation, sonoma:        "76a2904cf9ea10ea92527a16330dd67bec5a4180c61110c6011388053132c5a1"
    sha256 cellar: :any_skip_relocation, ventura:       "76a2904cf9ea10ea92527a16330dd67bec5a4180c61110c6011388053132c5a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1859983bfdce3115630b935d387eec365107b513237198c7309521396097f195"
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

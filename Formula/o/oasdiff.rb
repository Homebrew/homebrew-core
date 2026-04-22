class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "a2cc623689e4aceeeb6656cfd1317d0c020ac50a5367a4477970e7375a0bb4d9"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbc95025243808533ea852ca1cafa385a347f5b355908015e97cdc8d61ec22a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbc95025243808533ea852ca1cafa385a347f5b355908015e97cdc8d61ec22a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbc95025243808533ea852ca1cafa385a347f5b355908015e97cdc8d61ec22a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "67d2dec958ca7fca4ec0410d3a3a026614d52f5e164d20802d5cf3e6458276cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b30aa47817298cc42bfe35e5815c8abbad34861caff38d4d301ac887e06fc45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f16f1bb84dce0da6e85989856a71da2aae6f8bff70b21bd21db1f4861ff2dfda"
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

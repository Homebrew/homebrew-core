class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "3ea51c39bf0e055fb64a24c3a6858284617d74e84150ca7a03d2900ab6f2ed4f"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "912c9201a97c28b1f4efee4356b435f4eaa2e6adc7a0fe2de5dcd73fb8f68496"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac4f3a6da68482659915684a230602f433a372c7e0380cceb4bfd8885d215a63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "959c928c77248cad7147bcd746386a4bccd4ee58275106897ecda289d60ca492"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ad8501b78cd75b41a6559f74a5c97b55e198fa1b5f30c40b75e426f6e20c1e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15a7c6627e520df667655fffe712e8291de73a38af16de708de4aaceece68f41"
    sha256 cellar: :any,                 x86_64_linux:  "8a126e866ba3c4d37ad4bda50762ee28d56a4ffb9891310256f4ff5396601e15"
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

    expected = "3 error, 2 warning"
    assert_match expected, shell_output("#{bin}/oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}/oasdiff --version")
  end
end

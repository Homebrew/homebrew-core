class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.32.1.tar.gz"
  sha256 "6d75bf3cb1f02e8127066f650517234753708b0c542b5b21c70059f86627c141"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1bc133807193bca57c12b3d972bf4430f200a51c0babbaea92aa33e9a6ed3069"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1bc133807193bca57c12b3d972bf4430f200a51c0babbaea92aa33e9a6ed3069"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1bc133807193bca57c12b3d972bf4430f200a51c0babbaea92aa33e9a6ed3069"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ce718b6c1420234693b2a4d35fa4246eae1d3f57db07249355b2f0cda5b6c3bf"
    sha256 cellar: :any,                 x86_64_linux:      "28cfccdc44a74827aa0b5c357c9445e9901fd53158604559c387c443caab8d83"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/oasdiff/oasdiff/build.Version=#{version}"
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

    expected = "3 error, 1 warning"
    assert_match expected, shell_output("#{bin}/oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}/oasdiff --version")
  end
end

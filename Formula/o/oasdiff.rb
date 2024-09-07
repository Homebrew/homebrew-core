class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/Tufin/oasdiff/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "844884ee3d028de59faffd4aac76647cf4e7478f03cc11657489bac8ea7a6744"
  license "Apache-2.0"
  head "https://github.com/Tufin/oasdiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c62a4efbc1a388e4541f7f19c8cd8554b2bdc8c1271867f702e04cd5ce65bfd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c62a4efbc1a388e4541f7f19c8cd8554b2bdc8c1271867f702e04cd5ce65bfd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c62a4efbc1a388e4541f7f19c8cd8554b2bdc8c1271867f702e04cd5ce65bfd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "057ad1ec180f53d52b3617883b4a9345a34053d139f8f8b931f7313ef3d16f03"
    sha256 cellar: :any_skip_relocation, ventura:        "057ad1ec180f53d52b3617883b4a9345a34053d139f8f8b931f7313ef3d16f03"
    sha256 cellar: :any_skip_relocation, monterey:       "057ad1ec180f53d52b3617883b4a9345a34053d139f8f8b931f7313ef3d16f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c1ecbd0efc0d1e64d3458a9d52c63eee04ec7fa2f8f4be9189595e678238aa9"
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

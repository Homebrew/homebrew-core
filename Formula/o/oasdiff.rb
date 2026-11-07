class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "253f54eab83a4c00c656c98eadb1de18186b40c6870965ccd3035318be4270a3"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26d91191c758fa2b0d7ad238fef0216272575f65d02688c100edcc86f49a8495"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26d91191c758fa2b0d7ad238fef0216272575f65d02688c100edcc86f49a8495"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26d91191c758fa2b0d7ad238fef0216272575f65d02688c100edcc86f49a8495"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "39c1b3f13135124283a5399db96ea72d7c4801842231e1574e5316825b987361"
    sha256 cellar: :any,                 x86_64_linux:      "af9362deda45ce41133ad4c4cf0696d809859070dc23118773a94772b01f1dd1"
  end

  depends_on "go" => :build

  resource "homebrew-openapi-test1.yaml", :test do
    url "https://raw.githubusercontent.com/oasdiff/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test1.yaml"
    sha256 "f98cd3dc42c7d7a61c1056fa5a1bd3419b776758546cf932b03324c6c1878818"
  end

  resource "homebrew-openapi-test5.yaml", :test do
    url "https://raw.githubusercontent.com/oasdiff/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test5.yaml"
    sha256 "07e872b876df5afdc1933c2eca9ee18262aeab941dc5222c0ae58363d9eec567"
  end

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
    testpath.install resource("homebrew-openapi-test1.yaml")
    testpath.install resource("homebrew-openapi-test5.yaml")

    expected = "[api-path-removed-without-deprecation]"
    assert_match expected, shell_output("#{bin}/oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}/oasdiff --version")
  end
end

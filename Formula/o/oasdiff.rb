class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/Tufin/oasdiff/archive/refs/tags/v1.10.26.tar.gz"
  sha256 "678203c0e94ee7b6946419867eb6fd4d22cf2a9b6d6434e9be7431736b196807"
  license "Apache-2.0"
  head "https://github.com/Tufin/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2dddd150d2efa0a5eafff1bff8fd7d8f9ce827da3aaf772627cb38ebba6f03e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2dddd150d2efa0a5eafff1bff8fd7d8f9ce827da3aaf772627cb38ebba6f03e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2dddd150d2efa0a5eafff1bff8fd7d8f9ce827da3aaf772627cb38ebba6f03e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a836a76ab34d95dac6a382abe6c13d1b520fbb044f724803771be1cf36bef4cd"
    sha256 cellar: :any_skip_relocation, ventura:       "a836a76ab34d95dac6a382abe6c13d1b520fbb044f724803771be1cf36bef4cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a17e1c228cc2615d618f4bdedcb36297b0f56fbaf92cf646b18912e9474493aa"
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

class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.11.8.tar.gz"
  sha256 "f6e14198781dbc913796eca29cb6a11cc6522dbece38a34e6a5cb893fd9327a0"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ad6691fb0048d672d1f352ee34c0bfcc396c669b6f3f8c282bb6be66a0f2217"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ad6691fb0048d672d1f352ee34c0bfcc396c669b6f3f8c282bb6be66a0f2217"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ad6691fb0048d672d1f352ee34c0bfcc396c669b6f3f8c282bb6be66a0f2217"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6194b1569d264648af6217ba11a999881473d4db4611d89708c8c2e8c37aa2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a6454e0d752ebfb45e34e78771966634fa46f306c1ddab9df515146e3609443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d7f4cd69f3df66f5eaa75cbd639a56c3fbd650c3b86537c441986df73731125"
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

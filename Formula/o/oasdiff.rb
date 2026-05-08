class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "580c38d00a39e0b2a0f0c1df3e38cf66e3cce62a23118f0f03082951bee0c50c"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ba8b27ba65759d6c398df1a2de29be1bdaf2152379ee0f2699b2c3a4a6d2005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ba8b27ba65759d6c398df1a2de29be1bdaf2152379ee0f2699b2c3a4a6d2005"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ba8b27ba65759d6c398df1a2de29be1bdaf2152379ee0f2699b2c3a4a6d2005"
    sha256 cellar: :any_skip_relocation, sonoma:        "e037e749f8818e3dd34762b98bd9c8577ad97c109d70fb9a60383e9ffa194f42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34c41ec71dabdda97a0518cc180063b273c24db340ebc9a41fc162e55e35b8b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6272ed8f803d299b1d6a4a058178f3624f722e6e69fc0eb6f4d0b7b74ae66e30"
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

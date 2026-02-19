class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.11.10.tar.gz"
  sha256 "1e18a2f9efc4adcb501205d18095b82ec3fb52042b30f974d2bdacdea898bd17"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fd604b3a3ac32f99714c3c3a8540e3f57bb8cdbb39c3aee030ced2df42ed48c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fd604b3a3ac32f99714c3c3a8540e3f57bb8cdbb39c3aee030ced2df42ed48c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fd604b3a3ac32f99714c3c3a8540e3f57bb8cdbb39c3aee030ced2df42ed48c"
    sha256 cellar: :any_skip_relocation, sonoma:        "beebc669299e649dc4d301998d90f46bbf79a470b692c1a87beff05a271307fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ada830c3ef643a0463b6c3a89f0ad751805b72b8dcf71c5e61bbff6b3ec61e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "889dc6308c9b5cf3483a8de9a4dfed4bae652601ee2bb79beb69c70dd12aac86"
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

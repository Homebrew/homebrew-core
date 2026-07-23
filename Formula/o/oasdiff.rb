class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "4894a15817ff077681db5df33fa6df3d50f54579fa5c9afd5cbeb8f4bd4e4bb4"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fd9d0a3e14a9372b2f00f20b7142d1ab09fa782e3f168e72536b294214a25a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fd9d0a3e14a9372b2f00f20b7142d1ab09fa782e3f168e72536b294214a25a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fd9d0a3e14a9372b2f00f20b7142d1ab09fa782e3f168e72536b294214a25a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "acfa351302280eed5be813c856c1381af02e3390c883f64d65c37de3a8e9d56a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b23a5b283486d03c7bf6038b481ff50b378ba734226325edbee059487270336e"
    sha256 cellar: :any,                 x86_64_linux:  "a72c6e837f796d9e5ecc781ce2013ddcfedac308bacc44121bacd2b015dd574b"
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

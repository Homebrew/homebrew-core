class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.11.7.tar.gz"
  sha256 "bd06a38e62657634ab95ebc06174580fd3840fc07d8e5646eaed229d6dff424f"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b30a69746c46c6e2ab171dc35075133c80b84602d767cfe1cdd12767d5c11d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb82a39e44dcda2cc1c4c712c5f8f82c84e9d9f5109e5f8afdcd815c4edcb712"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb82a39e44dcda2cc1c4c712c5f8f82c84e9d9f5109e5f8afdcd815c4edcb712"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb82a39e44dcda2cc1c4c712c5f8f82c84e9d9f5109e5f8afdcd815c4edcb712"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0c386191ae5fd37be8dc2900796107df8ceedc03807fe4ed5fe5d3d9df0d9f7"
    sha256 cellar: :any_skip_relocation, ventura:       "a0c386191ae5fd37be8dc2900796107df8ceedc03807fe4ed5fe5d3d9df0d9f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13fba98e9166b1e63762f2ad442bd641507435846ea455655b70fe554d802f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adb371f77689c45db9bc52f4e47cc29d4da9ad9cb8dcd1abbd7464ce28e5ec1c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/oasdiff/oasdiff/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"oasdiff", "completion")
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

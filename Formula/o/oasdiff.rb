class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "d36ee5ac3face239375657a5251785981842e5a0ed9c57a93acf816aa72f3df1"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cec2e3436117fadf7991701dafe568e1840d48217d4cce1fabef5a1ccd80e16c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cec2e3436117fadf7991701dafe568e1840d48217d4cce1fabef5a1ccd80e16c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cec2e3436117fadf7991701dafe568e1840d48217d4cce1fabef5a1ccd80e16c"
    sha256 cellar: :any_skip_relocation, sonoma:        "60f7618e17366e992a866a45e92356d98303535ce3500f9dab55c6551a7070f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac45bf284a0b73aed0f5bec100d64166ae7d5a8624f67abb1de322c4ab5cd9c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d223f535326cd7780641aad61d34e4f7d545d1533c49829df1e663814d56644"
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

class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.12.6.tar.gz"
  sha256 "d26b0ccd6ab202f5043fba10adc85e6b33ec210d10663ed3450d96bf82efe596"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5820728516afa461e825a256d493d626035ca765cc2def2a685c8e69983eda05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5820728516afa461e825a256d493d626035ca765cc2def2a685c8e69983eda05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5820728516afa461e825a256d493d626035ca765cc2def2a685c8e69983eda05"
    sha256 cellar: :any_skip_relocation, sonoma:        "65dd2ab620ce5da4cc85b2c1798fdc51cef1f218c887ea378cc0a9e99dd83a0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21b9b6d02f995e84ef453aa19d7254f74867f3764594dc1b7d1cf0e28aa9325c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "357777a001a3f47a452c9bd4c98e4263180359a22558ea2f0e85fb242c4eaeba"
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

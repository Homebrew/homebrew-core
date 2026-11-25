class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "976969fc84c972d15a12f9a9abe3ddb173b6735d89f1283a8c83a69eead2f62f"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "eaa2679b6bf7f347ee3d945604147c33ccaa844fcc2740d065fde4ab00faf258"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b5ece3c1c4263c441a50c078c14de87552a01f3352c28bfd94c9609140ed07d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b5ece3c1c4263c441a50c078c14de87552a01f3352c28bfd94c9609140ed07d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b5ece3c1c4263c441a50c078c14de87552a01f3352c28bfd94c9609140ed07d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8d5bde3cf5f766edde48804d6de10589ce7c1bb5d23f3c69d65cef8368c5edf8"
    sha256 cellar: :any,                 x86_64_linux:      "e7ba731ad529ddba50bf80cc0425a9f9092ee23755f66b43c253f79c5669ae19"
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

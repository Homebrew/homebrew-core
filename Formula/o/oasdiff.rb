class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "75e2bf60dd2f0530385eb18fd1deb6daa0ea7f2d88600c23099ef93b716bfc09"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b1a088aff5389a7018629ae7e66c9d9726c2655b0fd78e712771211a8e3cec24"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b1a088aff5389a7018629ae7e66c9d9726c2655b0fd78e712771211a8e3cec24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1a088aff5389a7018629ae7e66c9d9726c2655b0fd78e712771211a8e3cec24"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5c8a0b674212d0f1582d4d9d9c910b4b0c228350ebd841ad855870abf851c3e6"
    sha256 cellar: :any,                 x86_64_linux:      "dffacb2ae5d57ebcfdf74d86991bf272d0e9c605a634b83fdc1adc914c1c5621"
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

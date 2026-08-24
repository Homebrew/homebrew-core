class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "50cc87718af4f052cae19b9929b3a454bf60b6fb9573aa026d3c0490d894b363"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3535e78437c17728161f9fa7101f93ac621a9990ff2dd4e87cc36d6e063bb8a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3535e78437c17728161f9fa7101f93ac621a9990ff2dd4e87cc36d6e063bb8a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3535e78437c17728161f9fa7101f93ac621a9990ff2dd4e87cc36d6e063bb8a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "83694a5c46ef63cea3e4746a9a33695ead44133a5f9f564db8605865203ed584"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d8eb4d6067f8e605c296ccc00a54bf84504509f71f9ab2efd6a78e07d731adc"
    sha256 cellar: :any,                 x86_64_linux:  "7d7080ab8da8bd6c6941079d1258b679f9142fe7812170de4f611e6971e5bbae"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/oasdiff/oasdiff/build.Version=#{version}"
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

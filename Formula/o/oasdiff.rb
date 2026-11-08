class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "cc8d7a4df7b7ef2947361af703e6deca1ac5739069f5618cb98f91627a5199d4"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4cf96f2a5a56e0aaa7f84dc616f11a23046e0b2a4831bd7f9330966a4d0b895c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4cf96f2a5a56e0aaa7f84dc616f11a23046e0b2a4831bd7f9330966a4d0b895c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4cf96f2a5a56e0aaa7f84dc616f11a23046e0b2a4831bd7f9330966a4d0b895c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "164e182ffd70f449053f49b56ad24d72a6d99a87d80e9b87c91196fb8b831833"
    sha256 cellar: :any,                 x86_64_linux:      "d5d42f6aeeec640f5e8e5d03e61ae8ebb95a325edb7000b62a347afc88a01365"
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

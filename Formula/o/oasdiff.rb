class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "cff06211dc3dd5c1ac2a3adced517a3baf840c5681d54b693763ff4856f6b6c0"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "004a3c4a897b47f5c7708c1e8f9f886ae479b39bb3b1e5da7d1b31ffa5d28a50"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "004a3c4a897b47f5c7708c1e8f9f886ae479b39bb3b1e5da7d1b31ffa5d28a50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "004a3c4a897b47f5c7708c1e8f9f886ae479b39bb3b1e5da7d1b31ffa5d28a50"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a1f548ee3d91be64cf7fdee6e7b9453af3f8a3d55a337f43e8b4bfeb2e2d8baf"
    sha256 cellar: :any,                 x86_64_linux:      "6f0a87d15f540194eba0c6126c2644dd38e70b98676bd1b21e1f83f42e62a850"
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

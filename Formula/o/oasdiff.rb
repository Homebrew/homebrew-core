class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "8ec2614d47e5a37a701ea18d7161cb3f7fdfc0717f21bfe71ec7dbdd6d065952"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "a0e6d1974f5a562007cdc6bf6643ec875a5cf543b37ba3f5072749098df9c52d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c6f29dd5825c3b63798aeadc929a767962e860d8f6340b7a79852ffec33bc181"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c6f29dd5825c3b63798aeadc929a767962e860d8f6340b7a79852ffec33bc181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c6f29dd5825c3b63798aeadc929a767962e860d8f6340b7a79852ffec33bc181"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "adda2b0998f9477c07fbe780ea7f1effcafd0a16b052cf04651c3c32a7128033"
    sha256 cellar: :any,                 x86_64_linux:      "620837fe1419a101e4bc8f3f73b76a38ecb16cee41e7dc44d69e53c223c7a7b3"
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

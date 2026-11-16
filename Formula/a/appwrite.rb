class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.13.0.tar.gz"
  sha256 "27cbf39b81b61645f3e89af364a3d88bf4b775406ab8db2440661c0956989ee3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b2fcba404ea6e3e5f93a3d97dfe2f94e3a40d8eda82f2e1f93c6f63a1e87664e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2fcba404ea6e3e5f93a3d97dfe2f94e3a40d8eda82f2e1f93c6f63a1e87664e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b2fcba404ea6e3e5f93a3d97dfe2f94e3a40d8eda82f2e1f93c6f63a1e87664e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e5e202cb1cda763a274810f60d433529702c8c94f90f1cf84e19d722adb88fbe"
    sha256 cellar: :any,                 x86_64_linux:      "f0cd5cab36e95847aac219018473880ec0e5dc5260f74b6e30d675c3c8e81953"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    # `go mod tidy` needs module metadata beyond what `go mod download` fetches
    system "go", "mod", "tidy"
  end

  def install
    # https://github.com/appwrite/sdk-for-cli/blob/4399a3321898f40cf982acbd4859d506c9d4d9f4/.goreleaser.yaml#L19-L22
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags: "-X github.com/appwrite/sdk-for-cli/internal/app.Version=#{version}")

    generate_completions_from_executable(bin/"appwrite", "completion")
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end

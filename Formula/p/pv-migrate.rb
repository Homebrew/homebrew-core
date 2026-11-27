class PvMigrate < Formula
  desc "CLI tool to migrate or backup/restore Kubernetes persistent volumes"
  homepage "https://github.com/utkuozdemir/pv-migrate"
  url "https://github.com/utkuozdemir/pv-migrate/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "7727a832439d75933d7ee92c8863a0c1f93299bfea0e7e6e744ce16b64f2c629"
  license "Apache-2.0"
  head "https://github.com/utkuozdemir/pv-migrate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "5ffd4ab3afe33a2c1eecedd9b3a54e4d4e37f14317f7d5bfa7ae44e789e7b0e7"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2c1905a809addd3bfa106b3d41f34d227e058156aa9327ef7fb3862d867ef701"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "19e42b48e40bd800b3ff5d579ab7fa217c96da32996b05367f869e498906c5c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c049cc8bf9b76819c3e5f2f13a6ff6ecbfda6241ed0ebd8da117b6598906eeb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "22945f0eaa538170233c4397796d0daf33b7076a471031ca55ebc2dd2eff9f5b"
    sha256 cellar: :any,                 x86_64_linux:      "fd308d090ce4b6dc070047ab0bde39cbf749cd4b69e1f8d5a50e6d62c27a1daf"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pv-migrate"

    generate_completions_from_executable(bin/"pv-migrate", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pv-migrate --version")
    output = shell_output("#{bin}/pv-migrate migrate 2>&1", 1)
    assert_match "source", output.downcase
  end
end

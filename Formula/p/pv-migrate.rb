class PvMigrate < Formula
  desc "CLI tool to migrate or backup/restore Kubernetes persistent volumes"
  homepage "https://github.com/utkuozdemir/pv-migrate"
  url "https://github.com/utkuozdemir/pv-migrate/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "f69a7d025369542544a438c0b5ea24227405c47e0c64a565605d77d290e72dea"
  license "Apache-2.0"
  head "https://github.com/utkuozdemir/pv-migrate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb5d1d90f2dc1fe444bc67018d59797a05df490f3900e1774b3c096d0d2ebf43"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "65f7cd1102f66dd709c24b4e3c863ffad8ddfdd05db12d007ce19fe2efcab3eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6cd45b90daadf92db74c818ed1ceb2478d6093698333e92045a4cc0e29865c95"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f1f4c7cce8db102960019011cf4451a59ac614eea60faed64f351b3e6637f314"
    sha256 cellar: :any,                 x86_64_linux:      "241a8846bc73f44b19056aa986dc32160ccab478b0ad1b7883843815e20a5f8e"
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

class PvMigrate < Formula
  desc "CLI tool to migrate or backup/restore Kubernetes persistent volumes"
  homepage "https://github.com/utkuozdemir/pv-migrate"
  url "https://github.com/utkuozdemir/pv-migrate/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "42c82639f48d5d58dd34ed5b7b07072b651a9b090b5955b99afd00153afa069f"
  license "Apache-2.0"
  head "https://github.com/utkuozdemir/pv-migrate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43b6b32f9c00c925c404dea8851dd656168d3a98845e14ed50ea7f0c026a18ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "14a59a43fce55ce7a213b3eb3c4401b6f24ee5b5112b527e37b19496947c3ab7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2dfae13eb7166064a7392937f48be2a360cf6cc0be4afc82c67426151627b354"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "88bf2a8e6a2420488bf4c0062744865c1a943885d94717880603037fd9f73090"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b4bd3c6ef60a325361368d9ef54463ce3a1f46db33e66ece7f28004a904a339d"
    sha256 cellar: :any,                 x86_64_linux:      "eff6014fd7b593c82cee9204535dfebf013ddf296f9a9a92051195fc085fbebf"
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

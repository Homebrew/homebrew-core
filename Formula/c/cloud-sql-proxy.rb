class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.26.2.tar.gz"
  sha256 "a048c667f59ac23e44df92d2811ddff8daf7da856bd810b9969427c409b750e5"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "44606e9788b325e5f6bdc7988ece52b507d31471ef5653f8fb2f9cb724f02a55"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c7ef4c5929f29634d104609183d70cb1c61d40e08cce678586928c15cc52d6bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bfe124afce738bb7386231607344469a55b1c99c153d557b7de37d0a2eded3a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "72878d979ad93920a2242569149ef89c3c4204fc2f173cb2676a16a0860cf1ae"
    sha256 cellar: :any,                 x86_64_linux:      "b4b9d0a79741b01f83b696cbaef63dfc893cee0765c6359f81aad6bd1853f0eb"
  end

  # TODO: unpin go@1.26 when Go 1.27's ML-DSA ClientHello no longer gets reset by TLS middleboxes
  # ref: https://github.com/golang/go/issues/81199
  depends_on "go@1.26" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"cloud-sql-proxy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end

class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v1.10.7",
      revision: "0a425352a80867ab7457e89414c3c30efd7d645c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "015935d382ef65596a96f0d36527ba6ce51576b4caf8ac3000f77d740c376fc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0af8b637ccc81a1f775e2f38c3e1dc1d60a08c64b916ac02d26fe6c1472769af"
    sha256 cellar: :any_skip_relocation, monterey:       "129ed0044c86ccece0985165ec1158cdb5b7fcdfd84e6e25a9b3c12132c042d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e3fc8e30be3ec3ce32373848d02350b73fe33cc12d01b88aada7a4292e3dc25"
    sha256 cellar: :any_skip_relocation, catalina:       "497d6dda3cb26b26da700bc6887b0edb315a93f6583a98a0b84c63dd19e401a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bc854e8748ed1fafca5c9d433a6a53e3fca5a892ad76798aa6f92a1f927836c"
  end

  depends_on "go" => :build

  conflicts_with "hydra", because: "both install `hydra` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/ory/hydra/driver/config.Version=v#{version}
      -X github.com/ory/hydra/driver/config.Date=#{time.iso8601}
      -X github.com/ory/hydra/driver/config.Commit=#{Utils.git_head}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "sqlite", "-o", bin/"hydra"
  end

  test do
    assert_match version.to_s, shell_output(bin/"hydra version")

    admin_port = free_port
    (testpath/"config.yaml").write <<~EOS
      dsn: memory
      serve:
        public:
          port: #{free_port}
        admin:
          port: #{admin_port}
    EOS

    fork { exec bin/"hydra", "serve", "all", "--config", "#{testpath}/config.yaml" }
    sleep 20

    endpoint = "https://127.0.0.1:#{admin_port}/"
    output = shell_output("#{bin}/hydra clients list --endpoint #{endpoint} --skip-tls-verify")
    assert_match "| CLIENT ID |", output
  end
end

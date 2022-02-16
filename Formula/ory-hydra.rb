class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v1.11.4",
      revision: "9e731b6e30b5aadd30fe3d7d8541db2331b11df2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bde60849c5b619cd4f6e972f41dc72c3ae6ecb46d4f7c5f903dc6a56848f33c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e411ed3848eb9c40b1218b462ab507238b2c5f6ec6bc2f1b1cf660779f70ca7"
    sha256 cellar: :any_skip_relocation, monterey:       "59c2de03cc784c1f217d969719d7b0e4d46407520550cbca276a4d09f674f477"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d80f44bf4f98a8454f713fd0acb75c8156ba1ba6cde7d5782f58926c669a524"
    sha256 cellar: :any_skip_relocation, catalina:       "9a00e12f8dada60f0f40b34894a3cee0974bf849ca01a06acabc744aead05279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3594d3c14d38ebd25add4a1cbb75e81d75f7393129f645a08feb00af66429443"
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

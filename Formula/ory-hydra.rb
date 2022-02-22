class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v1.11.5",
      revision: "743468eced1c8329d9b11b7a4cd5410e101bb05b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b2d902008fb3167ef0151d7e67dca096237a38155f045e37cdd9111ebc1a4c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18854e1851f9678910a06733af377638bbb48ef25099e5dbdf40d97449c54219"
    sha256 cellar: :any_skip_relocation, monterey:       "4e24c8095009cb8b7c4c01f8c181cacfcec160a6bf20142ddd3191a177cd2391"
    sha256 cellar: :any_skip_relocation, big_sur:        "a66195a3d504854f1f2d9bbd720394ad2c32e95dc3bd6fc5d9c0b2950119b2ae"
    sha256 cellar: :any_skip_relocation, catalina:       "84917abfb461c8732fe499efbbce9152e32de37d00868f0f4f4927a20e6d3a00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e8e5061ae6f67ef091751aa6ae11510cb3317ca5357922b05491d63adb17582"
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

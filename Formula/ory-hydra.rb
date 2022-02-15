class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v1.11.3",
      revision: "a3dd4ee051314730f14aa6b7731397fb6e9b90db"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "496af6a22f022c472dc0e030ab342865d75d2c6835aa11c6b47879b0e557e7e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12a3edffda69cfe01ccaacfaca098e5e6e4d1c61e39c83437f99c993f80d03c5"
    sha256 cellar: :any_skip_relocation, monterey:       "48f0734685f3e63a179a675aca8e21cfd7bf6cc535d0232f9d002f44f6db2bd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "1dfdf44850b9dc37bb3e2409c7d05d9a6046ba3bbc319adf543559f68ee5ca4c"
    sha256 cellar: :any_skip_relocation, catalina:       "0353f46d511400e9bfb4b59570b241da673fa978b9e9778a165ab652e84a2713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca9e609f12a6c6f9771c68474a6ae48b35bf0814096178e840e6a172d1ed3941"
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

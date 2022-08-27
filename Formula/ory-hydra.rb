class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v1.11.10",
      revision: "1a6c22070fc9550796c14b271e816be1dd1b8d78"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "926ca0e553ab3f744d91c22361ce5b67483df3f20b8d47f9e1bc9cd30d9ac810"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9dda4698b05e9d4125d7a86be4e0c548ede61b76a4b76d1332801de99c524b9"
    sha256 cellar: :any_skip_relocation, monterey:       "e44c9143beb252b5c4c51e2aab4cf296e499eb9c0b12124118c543c0ab706810"
    sha256 cellar: :any_skip_relocation, big_sur:        "572029a5c9606b6018b75984e5b3c9bee02a611df14c1dbdfa2d90748a75fc2a"
    sha256 cellar: :any_skip_relocation, catalina:       "08cc5e7dd4a8e8b955ef5104006a3d813055e5b7f9f4bca5af5158aceff83d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88ec60ce7dad48ba5fac880387ec8b96dae3017191f9acec05428917e560aa2d"
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

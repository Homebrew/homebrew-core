class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v1.10.6",
      revision: "f1771f13dd954b37330d4e90d89df41fc40be460"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bf42109921a8c635c52c5ab98965e69c29705a031a14c55c70330516e470c815"
    sha256 cellar: :any_skip_relocation, big_sur:       "0e722a796295f67092bb70106edee754d79e577f3d76c4a1332c4c5730da58f1"
    sha256 cellar: :any_skip_relocation, catalina:      "33748c928aba61b2c11917f5118748dc566edf25a3f2f637a3f711dd637f0e22"
    sha256 cellar: :any_skip_relocation, mojave:        "340958102c4350c52602fe9ac9a6707b716754d2f4280be4c37ca9f61113bd99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4b210ee85a24b7a6133fc5205af6a41bf187b3234ad4276780a55e24fe29cf5"
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

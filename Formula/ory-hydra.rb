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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "37f660bfd89f1bc766d06397f71087bdbc6ed7cea28f25e1ab282d55fb1ab19e"
    sha256 cellar: :any_skip_relocation, big_sur:       "db58ee23f24377e5db80a9137b7c30c596540125705292f19bb921d4bb573e4d"
    sha256 cellar: :any_skip_relocation, catalina:      "fc6c7dda2fee18826f95fecb6740219b090522bc95fe364efe8117dba9954c52"
    sha256 cellar: :any_skip_relocation, mojave:        "9a9c01bb5fc78a8b2e0ccabc85963687eac4b4251df7be3cf15911553765bef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81d3fc4944599a8101e9e0f985f0c3a84632c5bea97b72e6b531f2cdd3bdddbf"
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

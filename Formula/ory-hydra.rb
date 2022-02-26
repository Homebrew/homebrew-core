class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v1.11.7",
      revision: "510615bcc66231f90c29c1186c28f61366da7e52"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9d72055e14f9e9bd89ce296e61d5d1cb1c46a2c8de8aff7f769aef5fcca77eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44efc8d23accc1d9ad34c66c679799de7233bcbfd8ac544fc0e20526da17ffcb"
    sha256 cellar: :any_skip_relocation, monterey:       "61ea60605d2cca1e2de27a8017cd94fb48a60a27f1996ca10e8fecd05ea6e6f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1de638cbf92ac4f6a5d5e44595918e0209dcc618cb7da034841bc91f17eaf87c"
    sha256 cellar: :any_skip_relocation, catalina:       "b060d9b66b7765f8d7370cda96c68f7e5d320a85d8fbcaa728f3fdd9f22802c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a818bf44fc41a0100daa0457d346e0d00856592cd457848dbf66c2ea982ed626"
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

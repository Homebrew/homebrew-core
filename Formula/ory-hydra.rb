class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v1.11.8",
      revision: "337ab3ec2e363292ff93d5e5641a9b0bb87dba0c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11e8703aa4f4e271bf4b97dcc81d53022fc0cddfb8bfa94f9e5e7bc84a8b50c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1e773839019afe761fa2db55ce2dd2e7f08ecfed43e67634b9e94210d0be9d0"
    sha256 cellar: :any_skip_relocation, monterey:       "96ea51c0603c205ed168b4802d2928a8f39063f8b7cc5652b192d07816ee3c2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fda644a271b301e52ce9395bbae97f0c63be0c95c8cf32cfaf5e0977c3a316d"
    sha256 cellar: :any_skip_relocation, catalina:       "4cf91bdaa79eb91c0663e6b527bb9e621d5e73141a333248c68060d8d9a5fd81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe115f2896ef24689fa7389c41b2aeb54f26071ae259f16c8759abe06c7349b9"
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

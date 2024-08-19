class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v2.2.0",
      revision: "57096be9befbde4a1436ef48338d253a248c91c4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3462987e47255f538b486364533d4f06ef2839110a2cd27955eadaaf1b2619a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "786e9c5c5eaa1770cd127c8d20ed14e2394dfe9d60a0bdf5989372b4253902c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "747fa14d68354836f759157757541620003c362ced3c7ac4e19a3e88d2b46de0"
    sha256 cellar: :any_skip_relocation, sonoma:         "f03e0f5083bbea90e15a2f09db88d4d5bc42061417532b3f68b4191b2d9c9aaa"
    sha256 cellar: :any_skip_relocation, ventura:        "46cbcb0b1ec62a81da8861df9add4f2a1eab89b13064c19cfac915420dc83737"
    sha256 cellar: :any_skip_relocation, monterey:       "23b335c7baefd18dd5304455403dd7389b74a560d445cdbcb0197490128146b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "995c3e6a92c19dd5bca6250cd9e5d7c845376e492b758181a0de193977f2269a"
  end

  depends_on "go" => :build

  conflicts_with "hydra", because: "both install `hydra` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/ory/hydra/v2/driver/config.Version=v#{version}
      -X github.com/ory/hydra/v2/driver/config.Date=#{time.iso8601}
      -X github.com/ory/hydra/v2/driver/config.Commit=#{Utils.git_head}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags:), "-tags", "sqlite", "-o", bin/"hydra"
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

    endpoint = "http://127.0.0.1:#{admin_port}/"
    output = shell_output("#{bin}/hydra list clients --endpoint #{endpoint}")
    assert_match "CLIENT ID\tCLIENT SECRET", output
  end
end

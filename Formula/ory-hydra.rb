class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v2.0.3",
      revision: "16831c55c41e64dd73637e8e2ca8f22202fc7d87"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9d15e9b80b052ae775f90a2cdf5afcf9c038cfdfd4e5d491546592bb6547627"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20b66952fdca8d86647a6cd1c75d2751943ab4ca76d0810b73809d771129df81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd12dd9b97be0fcee0bcc6f5629b3f9737da78f8236973ed319ca7e8bf126a3d"
    sha256 cellar: :any_skip_relocation, ventura:        "b3a194d9aacc2a0a07c437acc9e1b560ab1eac2e559908683d440f872b112eb9"
    sha256 cellar: :any_skip_relocation, monterey:       "3e553aba26317647ac18bcb9e943f3cd9e464530d37fa7f84634cf0d6400ef5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f31f14c6202fae7ee8f690a597c0e390999ab3e1bc3f02492433b650b876f59"
    sha256 cellar: :any_skip_relocation, catalina:       "ad811cd6e1d05ddaa892d7a5d9247765681a8433ef1556491439abd8bc8f362a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88245f4115642dd8a9a12fa231d4f4bf33e2371111a142b971ca06a1ff395c28"
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

    endpoint = "http://127.0.0.1:#{admin_port}/"
    output = shell_output("#{bin}/hydra list clients --endpoint #{endpoint}")
    assert_match "CLIENT ID\tCLIENT SECRET", output
  end
end

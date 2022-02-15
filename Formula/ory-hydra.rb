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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c352db6fc5faf0432554f7f6c81236e7a2a12c38f50a533f05a2012ec1ff3d83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88a913c0c10f77b55597722d31d7c134139c2391d23b3330ff754fd481a7c13a"
    sha256 cellar: :any_skip_relocation, monterey:       "c6181e68ff6d323a1a3bdacca94e370e356afd354eaa1cdc2151999fcf2bf8f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a79f7fda793966544b2d6467b8ca5bfe4b3fc630aaea8bb982d134e9f8076eb1"
    sha256 cellar: :any_skip_relocation, catalina:       "4182e418da666db851574287eac0437544cb573cdd33b20527f2d7fd68ba1b62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32b4c742e6547400de1b0989909c577c0b1fc4a94ea543ecec889fad7017d8d8"
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

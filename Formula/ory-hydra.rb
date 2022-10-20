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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32800f07a1bbc749624f7c139b9da9b0e196a2838475b58e3832090801a256d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bf2d60166effbbc1279b573a8064be21c775b3fa1b2e71d1c5891fef164776a"
    sha256 cellar: :any_skip_relocation, monterey:       "f10ffc6b0011b51bca4d63ef1fac6e1dd5ebeae147c01e3ba38d21cb4ef8f73a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2391affbce3715d42bbe69bc84d1a6c82bec6cd567efc96e60fab323db5da563"
    sha256 cellar: :any_skip_relocation, catalina:       "f1b7c62a800ffe8f53267ebad12608d2ee3c25c23b7ea5e3f9c1f6a29e6a0818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7021751fe783eb552822118abf32ca9660d92bc87d1c1328ad8ef1765811e173"
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

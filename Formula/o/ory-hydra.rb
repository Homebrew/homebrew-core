class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v25.4.0",
      revision: "de9baaa9bc1b1865710d4e07e4bd0c4aca599447"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99bcc505b6e5a8cb0bb3e2b21695510b3aa3c6e684950d9372005581b6badaf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbaaf9558607784db178e4510ffcafc1331de7b1becbda4aa69f02e682f8273d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bceb901ec3dfc2d01f0c0cddef258092894c963280e5b304c6026e7e23b208e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4950121368b93bc7bdbd76e90f6d85fc99d6b78d9ad736ccb4fc03794780f75c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01afd4dea51ceb09f0fae57803eaa4097e6c2b7b40c5a320bbf6edb15349e780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72c69e079a5c665954ef23bf93b612c66b36d0f7bf5e32f07f33fca3369fcb36"
  end

  depends_on "go" => :build

  conflicts_with "hydra", because: "both install `hydra` binaries"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/ory/hydra/v2/driver/config.Version=v#{version}
      -X github.com/ory/hydra/v2/driver/config.Date=#{time.iso8601}
      -X github.com/ory/hydra/v2/driver/config.Commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "sqlite", output: bin/"hydra")

    generate_completions_from_executable(bin/"hydra", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hydra version")

    admin_port = free_port
    (testpath/"config.yaml").write <<~YAML
      dsn: memory
      serve:
        public:
          port: #{free_port}
        admin:
          port: #{admin_port}
    YAML

    spawn bin/"hydra", "serve", "all", "--config", testpath/"config.yaml"
    sleep 20

    endpoint = "http://127.0.0.1:#{admin_port}/"
    output = shell_output("#{bin}/hydra list clients --endpoint #{endpoint}")
    assert_match "CLIENT ID\tCLIENT SECRET", output
  end
end

class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v26.2.0",
      revision: "0b84568fffccf151dc5e6c7955fdfb738555bf4b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e6a5cf20f779808294e03f7e8699d40d2c19eb504addeb30c3339807ba499de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0219cdb3c7c76d3b9b4bc65c0d6b219c5b45fb177a02d16b2fba7d4a914ee13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2a92af11de6f8273a2387edb32e36c0fe151b72874f009b42a21732acf5fdd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "67270e24642d9e52c9c64117cd656067a1ec3c8499fd8aa5ceea52f6ca94dff4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df4be22645ba489172eb76c795c3fa43190d9f5ba078b8c563978f3114f3581a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86e6b0714024572615b390e4940778212e9eaad2623e3c09bb616c6080c86e4f"
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

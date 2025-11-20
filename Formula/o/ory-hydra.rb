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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "274aabae4b98765b98ce3f76009442d38da0bc5ddd0f7c742525b45f61f68026"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71b0f3ecf4c9d762e28c0181e6b2cac901027e7dafb7a3839bbab9898012838a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f11da4d0cde25e0b87efb35b4073da9071ca00699421572d04ebbc868a5969fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f69f9f90d69047df0462ff793e2685e1e04ff1135a7efb3b44da1b6ef68b3472"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ca48ceb1eaff823a4b9e9f8ad04f94f161407f3e8c83dc9aab5e232c2aec688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50dd566a516cde0ed8a8cbcc8a0771a61331c5ef275a2573e2275098330260bf"
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

    fork { exec bin/"hydra", "serve", "all", "--config", "#{testpath}/config.yaml" }
    sleep 20

    endpoint = "http://127.0.0.1:#{admin_port}/"
    output = shell_output("#{bin}/hydra list clients --endpoint #{endpoint}")
    assert_match "CLIENT ID\tCLIENT SECRET", output
  end
end

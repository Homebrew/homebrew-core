class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v2.3.0",
      revision: "ee8c339ddada3a42529c0416897abc32bad03bbb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c0a3f85167b48e6ea4b107c737e7e90fdbd4cfafe3a7d8b4be67facdb5af4c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07b89367b51ed83fa91e6d1de162a7f1b0d16c596b47f6b52006e9054b81ee9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b442320d9096b40cd35481016f883df160319e6b6060cf4ef6ec76820e957ea9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c8d55ca5dce7f630a4b23042ced6f1c35b1c187c55bdddb7ee05cff0a162826"
    sha256 cellar: :any_skip_relocation, ventura:       "6c4d52394e2726bf4c408dc69776d09a497c7456631a666b5115963a99a88803"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30944f8f85d029dfa84ded9ee820ca4bc9d7d9f865a0a0276a49b0ee2152df42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd7d10f4c7466d31197d3e5a2cf5196fe564f28f84236477b939a84fd7bd7bcb"
  end

  depends_on "go" => :build

  conflicts_with "hydra", because: "both install `hydra` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/ory/hydra/v2/driver/config.Version=v#{version}
      -X github.com/ory/hydra/v2/driver/config.Date=#{time.iso8601}
      -X github.com/ory/hydra/v2/driver/config.Commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "sqlite", output: bin/"hydra")
  end

  test do
    assert_match version.to_s, shell_output(bin/"hydra version")

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

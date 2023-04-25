class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v2.1.1",
      revision: "6efae7cfa7430cecaa145e2e71958699a2394115"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee77ae06108e3a9c25c4f44b4b0dac3e9a1fb397c9f0c79626f147ac2e161f25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd6d77c1c350154e814375ae9b5c41a6af8d05e6900c8aef4fadf52579c84715"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2be8c5285255ddcaab6a5b7f61c26a4c0f052aa7b3ed979e8a1781f4faff5094"
    sha256 cellar: :any_skip_relocation, ventura:        "5e063bd3350c4a5451b7f24e153720647597236aa9dcda16940e63676ca50eba"
    sha256 cellar: :any_skip_relocation, monterey:       "0cdae9c3ea5f31888827a7ff07f18ec6a908f203f8b9c4fe2bf674ec67999af4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9291c6fc70a8f9c3bd5e8aef795b1f6bdc6fd23faa108cfa32e07b5015a53375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "706bba9bcc870f85c649c852d945029d51384eb8e3139d53bb4ca89972d9af03"
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

class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v2.0.1",
      revision: "403223cc50bc0722102be96ff5631709f2b4e9f0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23e7994bd6b7f344e7a660ab0a1b86a608ecf1c105c49390ee9b92493df78612"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf2bda04ff69991b71771f6a914431af29bfc3a29cdd87b8c1ff42d29225c169"
    sha256 cellar: :any_skip_relocation, monterey:       "ef34f40650a152405ec1520854278c389369c4cbe0daa02ef9a8a31d7ac3cc23"
    sha256 cellar: :any_skip_relocation, big_sur:        "816dcac670ac7ba52db9699db14431f23379d3b6757c97ca9fe79ec52d517b1f"
    sha256 cellar: :any_skip_relocation, catalina:       "f5fba1b074190d458b0be58a7ab5a97a15e8be24aec3609bc8691c32b6b429d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2985fedd2d61af5e9a977e4d6d759f6f7bc2b0ea0a92aa9c5d49f9febce43390"
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

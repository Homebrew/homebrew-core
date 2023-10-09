class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v2.1.2",
      revision: "d94ed6e4486ee270d8903e6e9376134931a742d9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7a7f2570adc53ba58a9a30c59012b0bf2c577e7042c1a8002c9ecc372d1081f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9d6d61a8563173053f9a637227fb5edd661925e9259b82e6dc654c2c395871a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e69908730f69afc7358fcb2c211837c6052722bb5a73ef1751558210d272704"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ecfe722e401acf7db3e5e31e2c6bbec1e32cdfebf6644c7c4a198fc80998a75"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5c4fe8b86c651b777f9065cd049d98423e1599c0207b965c06a8fef6fdab154"
    sha256 cellar: :any_skip_relocation, ventura:        "ba404fa010880398c6ebc27848908d054f830ad9218353be4fc433f7ec3d6f30"
    sha256 cellar: :any_skip_relocation, monterey:       "bf6f34bc80c0eab1a4582f79234e7563ffe71a2b6261a30abedb5e47df4452a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8abde08a7d06376274d3158bd43f057c9d2ba9e152388962e6798beacf3a4dc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adfa14b17aa2056d30438f7541e334749646631777d018f0eec072d14f6be5f3"
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

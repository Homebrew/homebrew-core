class OryHydra < Formula
  desc "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider"
  homepage "https://www.ory.sh/hydra/"
  url "https://github.com/ory/hydra.git",
      tag:      "v1.11.2",
      revision: "7c099f8b4479a63a1dd582b3c09ff65a7a1008fe"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d7cee16415c9d5ce5c232251be0efab26dab6bd4e3482f878a4dab4f3b050d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46afefed899a63f3483f43ab5fa6be6518032a0b0547dce6add491a0bae1fc51"
    sha256 cellar: :any_skip_relocation, monterey:       "b985523cbc64b36e186ef6eb92f8d77065681bdb675cd28e53ef5ccab43f4a2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1dd16b524ff09da30831d23db2fa0c769f423e95b3025dc719fadb3723d8c2e"
    sha256 cellar: :any_skip_relocation, catalina:       "99b6e92811123be963be373d16d77ae13ab7c8af9e407d25c8d3ec122bf5412e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97f89d764e07fc62c43e3f0341900404a3eb890a130b3fbd820838676eab0d04"
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

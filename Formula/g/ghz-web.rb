class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/refs/tags/v0.118.0.tar.gz"
  sha256 "179bbc7ee390a6485074cc3c6ed8c2be141e386ba3a24e2b739c0d14ce60215a"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddfde41de469793bf3d5149a33a598f473ef16c1132c7e5353a0541238e3c94d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a926c86ce6d8893467d875aad808d70af45f68ed7f4da3408e852606557654ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e7bc73666c58ab425ef7055eed320f8d61b1db3a0283620127b0783d0cd8d0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9a0e4aaf2dde9d5d9c981417b20643a9baecf8c1186afc01082206862b0e17f"
    sha256 cellar: :any_skip_relocation, ventura:        "645baf62ecf1534b50d5da3bd9d0a0738ee043dcbf6caa1aa93a55c948c74406"
    sha256 cellar: :any_skip_relocation, monterey:       "02a6a2250c80caebc986676940efc5b991c5ad5ad0837e70928db085f015eb0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7c7e7c8017be498f7dc273e12d00c1760d70a8b609f99fbc97df0a5c6db4b9f"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmd/ghz-web/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    fork do
      exec "#{bin}/ghz-web"
    end
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match "200 OK", shell_output(cmd)
  end
end

class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.20.tar.gz"
  sha256 "9e50139247407198b775da32c3fe66def8c926427fc164c9bc5d38ce163b5615"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81ec7bf63ddd146ca34d50664f0cc4f3fc75a1ccbaf5f05cff2aa846bc6e5cfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "990830a21b502d8812a00509cd120ef37cdc674b8bab53e3cd41a50439d9b1b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8df6a6d32484cb52ad1ee05049e2de1dff10489fe05c0dadc92e68c7282fd3ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "7db54acb2dc7d1fede3b0a6f2f1fe304117fc19a5676dbcd3c89dd00a2c563de"
    sha256 cellar: :any_skip_relocation, ventura:        "fac566a960191c0dbb620b960a77df73729027e5e9c7c17bb2618e00e602e0a6"
    sha256 cellar: :any_skip_relocation, monterey:       "8dc317aac58c1ade8221aca3401a56588ad754267e6b1eb44e2904676fc85312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df78842181be149d29735c8e9dc30e4ecdaeb305344f2ddff8b8cafd8a20b869"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "cmd/pluto/main.go"
    generate_completions_from_executable(bin/"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~EOS
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    EOS
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml", 3)
  end
end

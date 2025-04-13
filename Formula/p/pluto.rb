class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.21.3.tar.gz"
  sha256 "725965cfc5b30eaacfcbc17c570f89fbbb4dd25b200a8211eb52100dfbb43219"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffb73fabd85be8350319f3da42ab54df06604885f6bc9d2cc2b9deb61777175f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffb73fabd85be8350319f3da42ab54df06604885f6bc9d2cc2b9deb61777175f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffb73fabd85be8350319f3da42ab54df06604885f6bc9d2cc2b9deb61777175f"
    sha256 cellar: :any_skip_relocation, sonoma:        "95e3417b42fb3537755b61c4bea354b3c631c9dedf6024098287bf510bdc96a3"
    sha256 cellar: :any_skip_relocation, ventura:       "95e3417b42fb3537755b61c4bea354b3c631c9dedf6024098287bf510bdc96a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b7cc93dfe4c47727629d4afdad1470eacb3bdafbd7d4abd9d1b2a8fa4f394fa"
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

    (testpath/"deployment.yaml").write <<~YAML
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    YAML
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml", 3)
  end
end

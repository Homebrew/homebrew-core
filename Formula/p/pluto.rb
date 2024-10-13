class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.20.3.tar.gz"
  sha256 "0e3991a8fd5e655953b1330a852a450dc26107ff77d1ceb20bd7464b86bd9e12"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44002232b5b5ca5fc361005304df7647dd7c544edf37e9edb4d30c9c0cd5aeda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44002232b5b5ca5fc361005304df7647dd7c544edf37e9edb4d30c9c0cd5aeda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44002232b5b5ca5fc361005304df7647dd7c544edf37e9edb4d30c9c0cd5aeda"
    sha256 cellar: :any_skip_relocation, sonoma:        "cddb8b1d62bf7cc33a7d789bc089ef31af24baf7fa7ba646587390197ef44736"
    sha256 cellar: :any_skip_relocation, ventura:       "cddb8b1d62bf7cc33a7d789bc089ef31af24baf7fa7ba646587390197ef44736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e6b2b713e40011b1625f67e5abd4bf67c0ab2f878ea51d2289f8c5b7e8d8879"
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

class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/v5.17.0.tar.gz"
  sha256 "1ab425da6a4d28da5bded463f833f7d5f29ee018da8cacf8c6393f94103d1105"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0577a52b4cfa6a371e44400f097c431598c8aa4fdd86d5cbcb9361e9b8648184"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0577a52b4cfa6a371e44400f097c431598c8aa4fdd86d5cbcb9361e9b8648184"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0577a52b4cfa6a371e44400f097c431598c8aa4fdd86d5cbcb9361e9b8648184"
    sha256 cellar: :any_skip_relocation, ventura:        "23f3c86bea892ad40b5a74ec5d2115acff4fe68cc241a0f2bc12bf982dc20c12"
    sha256 cellar: :any_skip_relocation, monterey:       "23f3c86bea892ad40b5a74ec5d2115acff4fe68cc241a0f2bc12bf982dc20c12"
    sha256 cellar: :any_skip_relocation, big_sur:        "23f3c86bea892ad40b5a74ec5d2115acff4fe68cc241a0f2bc12bf982dc20c12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce7039ddc5863e33a37422deb77678e5fceb600fb3f6800028dcb8a05511ed9d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/pluto/main.go"
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
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml")
  end
end

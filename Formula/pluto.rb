class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/v5.11.1.tar.gz"
  sha256 "96165bb03186e7531eead3d724e7d1ab6f68d9bbdda11d5705c0f0d6ec1726bf"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcf730a5417856905d812dbcfaf7ba1ec75d33d3dfc1191676f289aaa97eb28b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2e1ee49d5a050c4f08cbe7254608f1d9612d04ac9549900778eb16705d60d8b"
    sha256 cellar: :any_skip_relocation, monterey:       "a6909de0c03f85e5088573031b5fb5a08abbf0789990b372315a7e3af1ad3c03"
    sha256 cellar: :any_skip_relocation, big_sur:        "0540df60b1471469b58a2a21ae38c73fa866941ac1ca09f6894de1ae693f9b54"
    sha256 cellar: :any_skip_relocation, catalina:       "f823dacc4043b34094c1c538d95244581bd6c93e5a25038b087aa538ffca210d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85d3f0fb32daea753324f7f4da993702daa6ba27bb471ef093012a853d1fd0dd"
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
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml", 3)
  end
end

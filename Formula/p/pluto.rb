class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.21.4.tar.gz"
  sha256 "fe2b5444c36b8194be3d0a1615a8c5e1e45312d87aad97a3357e229c07469e89"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31445740c371b6114f22a4e9ee5f605aa41dc3309572723753c185c9be0f76a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31445740c371b6114f22a4e9ee5f605aa41dc3309572723753c185c9be0f76a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31445740c371b6114f22a4e9ee5f605aa41dc3309572723753c185c9be0f76a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "04c98e98ea8c5e13c5c1759b2923efee07ac7d16f077893cb87d4c7243a37a7a"
    sha256 cellar: :any_skip_relocation, ventura:       "04c98e98ea8c5e13c5c1759b2923efee07ac7d16f077893cb87d4c7243a37a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e620851cfb8601b915d837eece9de75ff08b0112bd78bed1322ee2b66488341"
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

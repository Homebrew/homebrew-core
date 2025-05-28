class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.21.7.tar.gz"
  sha256 "ae805581bc59438225a91c5d7a945deeda9d45662c82d17704fd460dc5b8b49a"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a14e783faf49fcfbc698477796695044c11b9e1c9f97c1a199c73f4a5b47eb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a14e783faf49fcfbc698477796695044c11b9e1c9f97c1a199c73f4a5b47eb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a14e783faf49fcfbc698477796695044c11b9e1c9f97c1a199c73f4a5b47eb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "527bbd3c7f504f06e1fe627a9111dfe936f249c0fc8fba5b644b9f2f76176853"
    sha256 cellar: :any_skip_relocation, ventura:       "527bbd3c7f504f06e1fe627a9111dfe936f249c0fc8fba5b644b9f2f76176853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9d55ff469acda549be1d1d50d8156ac1925a632406bea21235a61a10a17bd6f"
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

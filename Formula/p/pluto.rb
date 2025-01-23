class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.21.1.tar.gz"
  sha256 "7f1ccf20d1ebb50fa56ae67166266a1df2c19c2ff2643dac01fc9c54292d2bc4"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7e7711f995ae15b7e7c885fe261f4efec571250ed4f55e232d40d9540f097f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7e7711f995ae15b7e7c885fe261f4efec571250ed4f55e232d40d9540f097f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7e7711f995ae15b7e7c885fe261f4efec571250ed4f55e232d40d9540f097f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "10da9e31dd6d31bd392dcd03cf62d83025ed2d63c792189df30388ca7017499b"
    sha256 cellar: :any_skip_relocation, ventura:       "10da9e31dd6d31bd392dcd03cf62d83025ed2d63c792189df30388ca7017499b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33700d3f494f4c1d1a03c29be87baeeee4730206654353533dc527b29bd8cc12"
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

class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.21.9.tar.gz"
  sha256 "d798f5d02c8a010d193a35102b01d78b842cbcb3962415c11070c397f66b5e06"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a18c1da37a1e53762b24a96f7c85953be8a3af03f99d91c1ce4c1f74c54a6cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a18c1da37a1e53762b24a96f7c85953be8a3af03f99d91c1ce4c1f74c54a6cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a18c1da37a1e53762b24a96f7c85953be8a3af03f99d91c1ce4c1f74c54a6cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd453b3960d3cb510e5e9fec06f037c4e2ecdc421a0642199619107832d0e258"
    sha256 cellar: :any_skip_relocation, ventura:       "dd453b3960d3cb510e5e9fec06f037c4e2ecdc421a0642199619107832d0e258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "760da825782de531fb3baf3db161b357d556f580569a5179c88630a4c913adf5"
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

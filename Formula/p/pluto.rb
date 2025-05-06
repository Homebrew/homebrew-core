class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.21.5.tar.gz"
  sha256 "f179fc10c0055d88de5f9dd31ed47e3911fdb5cec05a5b6fd1ff2acaaf7d768e"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca5fc3001cd67ae628be3e6fdc68544ba40f44413583b328d673f533316cb4cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca5fc3001cd67ae628be3e6fdc68544ba40f44413583b328d673f533316cb4cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca5fc3001cd67ae628be3e6fdc68544ba40f44413583b328d673f533316cb4cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "54b7c95daa40d280869a01137da22b60bbd7fe55cbfa4aa191bb9ed36b4cb94f"
    sha256 cellar: :any_skip_relocation, ventura:       "54b7c95daa40d280869a01137da22b60bbd7fe55cbfa4aa191bb9ed36b4cb94f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3171647f28a46a652d95c638d36de606685586da3e37eb07e2b305cbecc867cf"
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

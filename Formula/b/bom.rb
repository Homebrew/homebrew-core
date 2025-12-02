class Bom < Formula
  desc "Utility to generate SPDX-compliant Bill of Materials manifests"
  homepage "https://kubernetes-sigs.github.io/bom/"
  url "https://github.com/kubernetes-sigs/bom/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "3893c25e7ea3b625c7c7c7d2f89cdd53fe6d8d43fac8c587a8f81c920498cca2"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/bom.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6db2ec5c4b09535a54d3d5d22d333082c00874771e37cf5ba956178621c5cc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6db2ec5c4b09535a54d3d5d22d333082c00874771e37cf5ba956178621c5cc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6db2ec5c4b09535a54d3d5d22d333082c00874771e37cf5ba956178621c5cc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c03b4702c232ee981567805de93cd236d5c1dacab4308b2d335a2dcd51cdf06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9876413b628df258e61da35b3cb16261a9004eee9ceb72c116d7f74c65a2d4e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "596ccf20880d7904ed00aceece1233e21f9685d0655e7cd9e83352401ee5525a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=v#{version}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bom"

    generate_completions_from_executable(bin/"bom", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bom version")

    (testpath/"hello.txt").write("hello\n")
    sbom = testpath/"sbom.spdx"
    system bin/"bom", "generate", "--format", "tag-value", "-n", "http://example.com/test",
                      "-f", testpath/"hello.txt", "-o", sbom

    assert_match "SPDXVersion: SPDX-2.3", sbom.read

    outline = shell_output("#{bin}/bom document outline #{sbom}")
    assert_match "📦 DESCRIBES 0 Packages", outline
    assert_match "📄 DESCRIBES 1 Files", outline
  end
end

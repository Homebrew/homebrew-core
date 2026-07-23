class Bom < Formula
  desc "Utility to generate SPDX-compliant Bill of Materials manifests"
  homepage "https://kubernetes-sigs.github.io/bom/"
  url "https://github.com/kubernetes-sigs/bom/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "3893c25e7ea3b625c7c7c7d2f89cdd53fe6d8d43fac8c587a8f81c920498cca2"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/bom.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b48f971e9f1eb27f2597c5b769d5c5b04c98b4a58e96d2a3518d4a70217a929"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b48f971e9f1eb27f2597c5b769d5c5b04c98b4a58e96d2a3518d4a70217a929"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b48f971e9f1eb27f2597c5b769d5c5b04c98b4a58e96d2a3518d4a70217a929"
    sha256 cellar: :any_skip_relocation, sonoma:        "24e9021594ab6c2789cbbd4bcdb40d8c5572091da769a155a89e83b577d3e79d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d745d7af5e11523d0717206e9f42265663b3c6b39e5eaa51e366474897d6e140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afd114ea53280a22f13d028a6c33e61e34193b24b54ac2ecf8e9c66db5e07b2f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=v#{version}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bom"

    generate_completions_from_executable(bin/"bom", shell_parameter_format: :cobra)
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

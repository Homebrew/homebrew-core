class Bom < Formula
  desc "Utility to generate SPDX-compliant Bill of Materials manifests"
  homepage "https://kubernetes-sigs.github.io/bom/"
  url "https://github.com/kubernetes-sigs/bom/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "1d411d8467c7fb9d3ed60d00a99614fb260a96aa533b727d50135b1ac46e9006"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/bom.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f26a57dc100765ebbd5d294cde8730bc73162bf2113f41f621213c8869a84f98"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f26a57dc100765ebbd5d294cde8730bc73162bf2113f41f621213c8869a84f98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f26a57dc100765ebbd5d294cde8730bc73162bf2113f41f621213c8869a84f98"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d6730ac5a8abf3be3c6dfe1998a2c115450fea6a018cbb28408fd8695fa8b080"
    sha256 cellar: :any,                 x86_64_linux:      "97c9870589efa245856d94242d5fbf4c97fc21e90811bb5b199c19c8c9f0d1d9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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

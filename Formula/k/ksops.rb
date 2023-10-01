class Ksops < Formula
  desc "Flexible Kustomize Plugin for SOPS Encrypted Resources"
  homepage "https://github.com/viaduct-ai/kustomize-sops"
  url "https://github.com/viaduct-ai/kustomize-sops/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "46f6cff603b5676f19bd0f4491c7d959e74848eb9f06b58494193522a1a8ebd4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7e324076fc702d99057b4d80c415e438141e1ce02dd2dbddbd228104305bcdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd3e25f2ae18519158931033936b7ff747fe4e1d2ac80c8a534a7928560ebf51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61d2fcae523d6da5d4516cd499ce0558dba6983d73ca1a05f83d08307b89db78"
    sha256 cellar: :any_skip_relocation, ventura:        "7b33a44e303f1b0f486dca09b5aa5adf67bf3797f7a5063504202cf18d75b310"
    sha256 cellar: :any_skip_relocation, monterey:       "f9a62e68c2a2a45aef933c36a15f150014150b72d333a9a3d8e73b3516681d1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ec80fb46fe7446b60c3c3822368f6788a7e10d6c34852f47581e49916a80cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3ec68212748d6ac5f7c4c85feb844862c82dd0a763f5267c5f2be63a50b82f3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"secret-generator.yaml").write <<~EOS
      apiVersion: viaduct.ai/v1
      kind: ksops
      metadata:
        name: secret-generator
        annotations:
          config.kubernetes.io/function: |
            exec:
              path: ksops
      files: []
    EOS
    system bin/"ksops", testpath/"secret-generator.yaml"
  end
end

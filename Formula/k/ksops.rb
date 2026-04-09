class Ksops < Formula
  desc "Flexible Kustomize Plugin for SOPS Encrypted Resources"
  homepage "https://github.com/viaduct-ai/kustomize-sops"
  url "https://github.com/viaduct-ai/kustomize-sops/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "c3c6ce4503cab59a3ee345ba771cee01caccd99d1ee9f3668f58214cd5ef6742"
  license "Apache-2.0"
  head "https://github.com/viaduct-ai/kustomize-sops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "364262faf875534b99ccc31bd7927081d4fe7cd621a76a56c301a6ab67f1a469"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "364262faf875534b99ccc31bd7927081d4fe7cd621a76a56c301a6ab67f1a469"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "364262faf875534b99ccc31bd7927081d4fe7cd621a76a56c301a6ab67f1a469"
    sha256 cellar: :any_skip_relocation, sonoma:        "52792d1cb8bd04bc47e4879360db2941e1baf75858a7c60a70cb9763ebeecfea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b126ac5047ce953ed01692c3e66a8e81a43ee92ec39c604f9bf0a65a7d7f931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6db3f9f9fc371dfa67d4fac397b1534af08e6b23ee6009e0eaa9269c101ffd96"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"secret-generator.yaml").write <<~YAML
      apiVersion: viaduct.ai/v1
      kind: ksops
      metadata:
        name: secret-generator
        annotations:
          config.kubernetes.io/function: |
            exec:
              path: ksops
      files: []
    YAML

    system bin/"ksops", testpath/"secret-generator.yaml"
  end
end

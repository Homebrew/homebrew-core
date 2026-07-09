class Ksops < Formula
  desc "Flexible Kustomize Plugin for SOPS Encrypted Resources"
  homepage "https://github.com/viaduct-ai/kustomize-sops"
  url "https://github.com/viaduct-ai/kustomize-sops/archive/refs/tags/v4.5.1.tar.gz"
  sha256 "c3cd2b77e6adb4cc84bcaad8cbd751ee0c633bed2f835ac85ce2bc969d21a88b"
  license "Apache-2.0"
  head "https://github.com/viaduct-ai/kustomize-sops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cf3c5fab0551b7ba2b5bc1b166046bce3b1050d5876ee09ecadf36bae9d5130"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cf3c5fab0551b7ba2b5bc1b166046bce3b1050d5876ee09ecadf36bae9d5130"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cf3c5fab0551b7ba2b5bc1b166046bce3b1050d5876ee09ecadf36bae9d5130"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa62ceb900c50e3c2c583257edbd5bf881e1b233c8b4b797b90b2e510347ab4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21bfa69a3ec57d2180770c83113f6b5d5ad3c699e750caffc0264f27ab0089e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aab175011c839c14d07bf473b2f7ebd3bd30037b677c1aaf4c848035013c332"
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

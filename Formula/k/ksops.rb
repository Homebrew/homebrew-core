class Ksops < Formula
  desc "Flexible Kustomize Plugin for SOPS Encrypted Resources"
  homepage "https://github.com/viaduct-ai/kustomize-sops"
  url "https://github.com/viaduct-ai/kustomize-sops/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "0e9501af7ac0323d246c9fa4d49d9f12fe4ddf65be21e9fbbe58a041dbfbeece"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7be87fae2bd05f216b4ae5d6658ba5304fb8df6856a44d22800ea9f725ee46a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7be87fae2bd05f216b4ae5d6658ba5304fb8df6856a44d22800ea9f725ee46a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7be87fae2bd05f216b4ae5d6658ba5304fb8df6856a44d22800ea9f725ee46a4"
    sha256 cellar: :any_skip_relocation, ventura:        "d4033ab623c841873a1ab5ac10e54e315f2cdd18e7cfb4fea26dac9535353956"
    sha256 cellar: :any_skip_relocation, monterey:       "d4033ab623c841873a1ab5ac10e54e315f2cdd18e7cfb4fea26dac9535353956"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4033ab623c841873a1ab5ac10e54e315f2cdd18e7cfb4fea26dac9535353956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac116c085b91608fcce4350d0af4c8f97d88525a983f3f93acbc161150f9d875"
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

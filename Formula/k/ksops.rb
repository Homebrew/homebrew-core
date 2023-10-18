class Ksops < Formula
  desc "Flexible Kustomize Plugin for SOPS Encrypted Resources"
  homepage "https://github.com/viaduct-ai/kustomize-sops"
  url "https://github.com/viaduct-ai/kustomize-sops/archive/refs/tags/v4.2.4.tar.gz"
  sha256 "f0d1bf41a78bf4b57cc15abf6d43beaf5a31d1d5425c74d00d11c2c27533051c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08dc2c5b98f73866fc86ef946c854d30dfc0b30f6083c4db8b030b3b66a53909"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa649717db52e69d63ae0247a1af9e8e5dbc07c24eccc65ddb4b96b8cbfbd06a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feb0a40c36e75d47c8795c06c3f118ba40fe2478438385d3119ede2228e44298"
    sha256 cellar: :any_skip_relocation, sonoma:         "edf17a9dfd4c00860c7f5b16fa0f8f53217ed87fb9a2daf0d69acaf43032531c"
    sha256 cellar: :any_skip_relocation, ventura:        "8a85290a2261b5ee66ea66738e76f31aa39e6dcafe6439a0f1f51a85e36da1dd"
    sha256 cellar: :any_skip_relocation, monterey:       "20c89440201b23c6cd5542f5b212e0374a2d8f2e1b4801e756f304592839e8ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c0d9de93199100c7793526c0bcbfe9af0ea1e70bebb739b6c29cefba235622e"
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

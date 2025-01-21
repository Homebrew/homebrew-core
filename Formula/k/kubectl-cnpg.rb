class KubectlCnpg < Formula
  desc "CloudNativePG plugin for kubectl"
  homepage "https://cloudnative-pg.io/"
  url "https://github.com/cloudnative-pg/cloudnative-pg.git",
      tag:      "v1.25.0",
      revision: "bad5a251642655399eca392abf5d981668fbd8cc"
  license "Apache-2.0"
  head "https://github.com/cloudnative-pg/cloudnative-pg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e92a8756b154285685c18d1738e8a783252904af8e3ebda03e83a6d036c7e1fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34d6c8efc441f2a685cb0ee1eed719dc456a0922502e415fd50dced06fb60ac2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "620717e5479cb447b847566f6c36b479f29a865f29db6e1d2df9957e4b3b0564"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb3124ab51bea65aa257bdeecb3ad7dde40e38dd51852be1f9f8a5300d0699de"
    sha256 cellar: :any_skip_relocation, ventura:       "b00fcebd62d0134dc4f63efa000525d0abc34a42318cbf82896a465727022a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65daefa85de163c34cba14a4d0ac3d5d04385b87dd4aacef3e1f043d72b1805b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cloudnative-pg/cloudnative-pg/pkg/versions.buildVersion=#{version}
      -X github.com/cloudnative-pg/cloudnative-pg/pkg/versions.buildCommit=#{Utils.git_head}
      -X github.com/cloudnative-pg/cloudnative-pg/pkg/versions.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kubectl-cnpg"
    generate_completions_from_executable(bin/"kubectl-cnpg", "completion")

    kubectl_plugin_completion = <<~EOS
      #!/usr/bin/env sh
      # Call the __complete command passing it all arguments
      kubectl cnpg __complete "$@"
    EOS

    (bin/"kubectl_complete-cnpg").write(kubectl_plugin_completion)
    chmod 0755, bin/"kubectl_complete-cnpg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubectl-cnpg version")
    assert_match "connect: connection refused", shell_output("#{bin}/kubectl-cnpg status dummy-cluster 2>&1", 1)
  end
end

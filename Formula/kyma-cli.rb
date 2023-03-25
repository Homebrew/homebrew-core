class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.12.1.tar.gz"
  sha256 "577897078e50521287705075bbdcc5a567442407ac4b393a7b66cf58834e587d"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59d727b28cb5f7ecf98eeac3359051daed4f61f130dc06c55d1d1f0fdaf01f50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a095f939f81e7f804ea7caa3f7d12dec9e3d651e975c7c83d294e9817bfeed5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a4f1a8ebd97116aae8c8c1cd704ef5fa0f6d976f4ce32f4d0cf80bc4c680b27"
    sha256 cellar: :any_skip_relocation, ventura:        "5bcb1373574090b243ecc82ff41d563a5de1032f99f46e7304c017d3ccee2dd5"
    sha256 cellar: :any_skip_relocation, monterey:       "1e5508c2a1bcc50e74736b67abf8fe0191912932583b986e689b4dbc48127827"
    sha256 cellar: :any_skip_relocation, big_sur:        "73081e5a12bcaa256330c0bcf91928cec7487c3f46cab3a7840ad61ed81ca9ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c3984be51000f6d21c1eb9f858bc27bd28afdfc09542baf0c3935fcc97edb53"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"kyma", "completion", base_name: "kyma")
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 1)
  end
end

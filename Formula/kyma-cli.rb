class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/1.18.0.tar.gz"
  sha256 "698f693f5f70a7f2ff91831d6ef8fdc10d1ceace81e985b4c2ca02a73fddcc48"
  license "Apache-2.0"
  revision 1
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de0f40c53e6b00c59dafbb87ed608acc0df7f14b964c40f54d54479b1e4e1975" => :big_sur
    sha256 "2f45d170e2d44019c8ca35488c8eb8cee2159622dd2de7315640f7f0af16dc25" => :catalina
    sha256 "f9a8fb1caacaa7deaa8b08ccb09b8c875b8491c854e9fffe25ce704d68add947" => :mojave
  end

  depends_on "go@1.14" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
      -X github.com/kyma-project/cli/cmd/kyma/install.DefaultKymaVersion=master
      -X github.com/kyma-project/cli/cmd/kyma/upgrade.DefaultKymaVersion=master
    ].join(" ")

    system "go", "build", *std_go_args, "-o", bin/"kyma", "-ldflags", ldflags, "./cmd"
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end

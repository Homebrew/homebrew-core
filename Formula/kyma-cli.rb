class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/1.24.4.tar.gz"
  sha256 "738bbb2660017b59bd20b4c6a9f4316743b3b6b8ef4a8f9ce6f03b654060efdf"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f77ea7dbfdafcd9763f8fe4fe2dbb0399a3aec2f7b16c8422173d1392026f886"
    sha256 cellar: :any_skip_relocation, big_sur:       "d29d9c8e01195ba6a693b7700c93337fbb0bbc218c94699f03480eb2d96904fa"
    sha256 cellar: :any_skip_relocation, catalina:      "c9c75c10ca31b346ac9d713370dd172e3ba77745520c6b1134f654b4ea0058cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7003854cb91ed75176e43e7c406e4ef3a60c54e12f962145b6b0ebcef44e7a9b"
  end

  depends_on "go" => :build
  depends_on macos: :catalina

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
      -X github.com/kyma-project/cli/cmd/kyma/install.DefaultKymaVersion=#{version}
      -X github.com/kyma-project/cli/cmd/kyma/upgrade.DefaultKymaVersion=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-o", bin/"kyma", "-ldflags", ldflags, "./cmd"
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end

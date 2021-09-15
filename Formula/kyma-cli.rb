class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/1.24.5.tar.gz"
  sha256 "a66fb6a1e4ced18e3b0acae028447f93245b9652ff3472b582227d5a532d2849"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f55e4ee54eb0e97812773baa0362c43e12fa75e811323f6e5a19298732b567d4"
    sha256 cellar: :any_skip_relocation, big_sur:       "b5744f6c5b87c2fa0749c3cd754af86fcc5f8b2f0f095852becf7996a1c729ce"
    sha256 cellar: :any_skip_relocation, catalina:      "9d4d836f1f542c7dc48c4f9ace772b756dacfedf0255bc87838d01f15a2bc9a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4a6a28b480da61c04993e52d817d20fe5870cf3b4803cb65a8473e06319ef6e"
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

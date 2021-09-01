class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/1.24.5.tar.gz"
  sha256 "a66fb6a1e4ced18e3b0acae028447f93245b9652ff3472b582227d5a532d2849"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "002abb8885e6bb868c795162aabd334b3131cfe22a8372d17e73b7be034ea8f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b04e86c9acf19ace877e9517c753a8e3379062f4eec3e738d43f02c9ca1c0a1"
    sha256 cellar: :any_skip_relocation, catalina:      "775804744e8e9ac709e46b8ef2b65abc62ea127cffbd2c79ab9b2db55943a40a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ada3b5c8dbaf0d3646c80e424e9eca30823dc710e11726879c59ef5b6d1fb25"
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

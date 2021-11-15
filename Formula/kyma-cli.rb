class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/1.24.8.tar.gz"
  sha256 "eb4d3fe1877f025f240a322693e882b2c52cb6d87c9bf07ae9970536283aff58"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72984a1206b8d212c039da725314b9f1da2ced7146064b5133c333826c38710a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78008ecff4dfd2abead735426e5247f7d08426ad969d9e9db0fb404d82a4a337"
    sha256 cellar: :any_skip_relocation, monterey:       "79ac3433a90fc3fc5a1dc0a7a21452f2bcf0c11c0bb643fe5cbdb9e0cf48aca8"
    sha256 cellar: :any_skip_relocation, big_sur:        "06d50c0461daff888dd1d6eb8724cbc4f14e7c9adf2544ef54b2b29a92515037"
    sha256 cellar: :any_skip_relocation, catalina:       "b87e26c7cfcd1321086a1dd780ac7837b78339683f95513b66f86be2dc15b83c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc4ed5563a4cf5b2b9396dc1fa11d89deb1d87df33adabe5a4d05d72c5bd73fc"
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

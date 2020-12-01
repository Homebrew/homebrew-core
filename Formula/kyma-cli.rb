class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/1.17.0.tar.gz"
  sha256 "dc700e977cc7e1b12b3dd9f12e3ae5276cb710c98dd01f9d336c360f9a605777"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "02eac441770cf4244ff275489f597a9ceeede0ae4ddb09e49a69a7e89b5ca3d7" => :big_sur
    sha256 "4366d652edb19f7c46454607de15f5eea7092ae0bfb7723fb84cb950b2a4211d" => :catalina
    sha256 "a128466fb724f79119318fe080db1f88c591485a4b0c6c4c1ada4aae76bdfd3f" => :mojave
    sha256 "04c3120713e92b6ebe1d6aaf07445f514dd282e917da80cc4225093070ef595e" => :high_sierra
  end

  depends_on "go@1.14" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-o", bin/"kyma", "-ldflags", ldflags, "./cmd"
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end

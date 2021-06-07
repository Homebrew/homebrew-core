class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.12.15.tar.gz"
  sha256 "05e898b9cf42e2a847ae9ccf63cb2ef9449b1e7d4b786ebf13054b790fea51ee"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3693b68822f6dfff3c910b871505414c2f1f82df61b44ae97ca76475fe41beae"
    sha256 cellar: :any_skip_relocation, big_sur:       "dee8ccb91daafca424aa0cb892eddb152484bda09c1081cb0c6578ca71482ef7"
    sha256 cellar: :any_skip_relocation, catalina:      "997a85645544cb6ecf6eae8ef2cbfc2050de14443e0aacabec78157bc1428b6d"
    sha256 cellar: :any_skip_relocation, mojave:        "24fe1622bed61b6c3f3795bec67ebca107e32afac7f415e48973c80abb1bbdeb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    touch "test.rb"
    assert_match "Failed to load your local Kubeconfig",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1")
  end
end

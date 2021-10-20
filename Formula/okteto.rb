class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.14.1.tar.gz"
  sha256 "9f9579222535b20f9d403f696ff3cecbcec6f746d97c76e5d98e839e8af22540"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7d9d48103383c927c43f1f70a0331cbc4bcd3b1050dea91535db1c16140c6df7"
    sha256 cellar: :any_skip_relocation, big_sur:       "17ae7f6ea66cdedd219d882cad965f4daacc42c134e25f1dfd3462b27d00b862"
    sha256 cellar: :any_skip_relocation, catalina:      "5ee0985dbfbc0732806db3b0d7711fb310a8c0e78a73225f7ae0df6d24b63657"
    sha256 cellar: :any_skip_relocation, mojave:        "69555ba18eda1cf5fe1cbdade65f8424d2128da01ed4739768b170565b5749e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05aa54d06560b4d33f1d3657550c68d2675aafc491f7c68fdac5f03df105eef7"
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

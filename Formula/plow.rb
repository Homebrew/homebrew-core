class Plow < Formula
  desc "High-performance and real-time metrics displaying HTTP benchmarking tool"
  homepage "https://github.com/six-ddc/plow"
  url "https://github.com/six-ddc/plow/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "aa579bfa7fee552d84723b6f49d7851759bfd2ff15c9a5d0f216c11a838472a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efe290ac3d86bec107df0e22c15f4cbdf960dc88df929b4a7b578440b3412389"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb13e15c3cb95c4e9ae36c498f5eafbbe2401bba7846e3eef7764e56927bafb2"
    sha256 cellar: :any_skip_relocation, monterey:       "f42f7ff80afff18956562d7c1d98a09571efb50951fe88e8363d2a16caa74dd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "35efcee910b6391bcb00a74e174bd2c7961742c75b7ce5d81cf739f5f8907e41"
    sha256 cellar: :any_skip_relocation, catalina:       "d30cae49b41472ed81c454b2e5ef2031e1e46307f8b838b4892fedd80c41d318"
    sha256 cellar: :any_skip_relocation, mojave:         "beb6ba83885124eb4ba8e2e4bb5bcaf8951bb574ef8d9b94c2c48307b92caff6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = "2xx"
    assert_match output.to_s, shell_output("#{bin}/plow -n 1 https://httpbin.org/get")
  end
end

class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.11.2",
      revision: "944939944ca4cc58a11ace4af714083cfcd9a3c7"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdf160fae0585a6a978d06cbe69a984ac8b32a6217f9ba23f9162542db065f6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1d12d994c6a23efeb0ddc1a96229bb60a9efce0a0f3268be3e6cfacbee11077"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a776ce2cba369a4ff948627d145b94ccbfb15cfc0353a71b850a3c230628180"
    sha256 cellar: :any_skip_relocation, ventura:        "bd20dcdaa4e9c306ef90050179f684792c62347d0da0fa5a9ee10fd965fdcc52"
    sha256 cellar: :any_skip_relocation, monterey:       "0874893cf5161b93f65a431bd623859afda6fb0462d0e6696003f5e09d85f741"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c7f6b4c60a0a97a0b1d231a30740ab619e4e97aab022eb329df0a226dd36d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20ad32ac962ee4572dee04604ca856dcbc95258930db480447c9e841c2de640b"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_head
    ldflags = %W[
      -s -w
      -X github.com/moby/buildkit/version.Version=#{version}
      -X github.com/moby/buildkit/version.Revision=#{revision}
      -X github.com/moby/buildkit/version.Package=github.com/moby/buildkit
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags, output: bin/"buildctl"), "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/buildctl --version")
  end
end

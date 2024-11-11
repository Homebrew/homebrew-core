class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.3.89.tar.gz"
  sha256 "6e11d8e87f4a8c0431b75e15b767b601faded26394716ffd0da3bb3424c5ef1d"
  license "Apache-2.0"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e465dbc3c5c06f6579c8cea3ce8254916c1319f9d0601bfe835b7aed27359098"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6504b441780d4a6be6a883e6fc79961f80f605af61e5a538c4997648762823d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54324fb7aa4512940414abd7b7d561ee8418acd22a53381fe5af1e8c5fdbee6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c310aa78fe1095ddcca0a9bc3c10c4566f9b21d7877b91732bb467f9b5f234a"
    sha256 cellar: :any_skip_relocation, ventura:       "71e108f7d4f26aa261a9a81d21978ea2f9ca3d7168bf91d6d12f5039dfeed464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba268e32e7c3c9545f551613f46f6fee9f1d2e5157ee2db20dd9e374e97d4930"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X "github.com/kubeshark/kubeshark/misc.Platform=#{OS.kernel_name}_#{Hardware::CPU.arch}"
      -X "github.com/kubeshark/kubeshark/misc.BuildTimestamp=#{time}"
      -X "github.com/kubeshark/kubeshark/misc.Ver=v#{version}"
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    version_output = shell_output("#{bin}/kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}/kubeshark tap 2>&1")
    assert_match ".kube/config: no such file or directory", tap_output
  end
end

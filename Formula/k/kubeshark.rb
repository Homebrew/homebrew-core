class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.7.8.tar.gz"
  sha256 "02d518b9d0033862e64f1d7436fcc287970ba2a072a815b44c8191bfc1329d19"
  license "Apache-2.0"
  head "https://github.com/kubeshark/kubeshark.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "653d103ab81cc6b27c279206b6995933f558fc788be19c9e758e3ac8bd0e22d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75f9a2b3f4352584446310817b41349a1468c1486aef4e757be96fe00ff77752"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c17db772424fe86efb5f944bf818a69cb3d1504db0f8c5b11b447d0a4b7675a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb0be7ced12c2b8d41ac0492bc67423a723ef785cbb5c674343dea9cddf7c884"
    sha256 cellar: :any_skip_relocation, ventura:       "990281b1ced837cb3e3ea95a3bd923354b45d23a87c141959951496a03c125c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e392abb9fba2ae3c5159cbab05d1cf77537442ef9b637d472e72109908cd554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "885ef7fb3f9c89985ad456b95c10b1f03863b61bfbf364b776031dbeaccd5778"
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

    generate_completions_from_executable(bin/"kubeshark", "completion")
  end

  test do
    version_output = shell_output("#{bin}/kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}/kubeshark tap 2>&1")
    assert_match ".kube/config: no such file or directory", tap_output
  end
end

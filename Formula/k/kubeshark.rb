class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://www.kubeshark.co/"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v52.6.0.tar.gz"
  sha256 "5268a07c37abbba881c5342ebc66302206735e688f8463599ba3ec7ae79857f4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ceb287f05736d7f3fad856aa88a13ac02bece4f82796fe987ff153435a4bade8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9db3468748d6471bbf3bfea738d30a1e4cb9329b9893d25ee4c4418122cd21ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09c1a55b8805d2a498e7c5749ebcfc07a30e918f18e5adfc8529eb1045cefbed"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2f1e532848a6a48f6a3a5776d71358f50b9c5cac59c389b35eaea9c05845cb0"
    sha256 cellar: :any_skip_relocation, ventura:       "da083374f0d641e501a53099e7ed534cc8307ce359a63297ad45c5ea271324ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "334227606939c53834d7778fa51071a5f7cd1a729d271291de55d36711c13fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cf3fa6844a66605b10db46ff9220c00b224feffb01a5ac8820afab372df4249"
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

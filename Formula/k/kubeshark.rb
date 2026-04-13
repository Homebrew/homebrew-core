class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://kubeshark.com"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v53.2.0.tar.gz"
  sha256 "8d7e17587d674ca1d504cc3aa27a3148cd10f2133c605ed0a82b5e1ec8f835a9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c13c4f66f5d37f6f342f567675ccee27dc09c0df354d11c56cd51a955e64990"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cb3db6c612f932d2f26a08358544dc0b7bb3ceeaaa60cbd0cfe75fd4a26470a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2f58fb32d56800f79bac69f05518ee611a414cb5f2284fb9b4e31d64a810515"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6474b327df02254cbacaccf1c9ca8c453211dee9f237e1a243768ccb3a7c5bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62f0a6653cde3a181b32abcf57941bcda613e468cb3cbc87bec06e1a2ce6ac1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fbeb5dcde9797196dfedbcfe28eb3d66fb7594932d4b76ddea42533a9476f31"
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

    generate_completions_from_executable(bin/"kubeshark", shell_parameter_format: :cobra)
  end

  test do
    version_output = shell_output("#{bin}/kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}/kubeshark tap 2>&1")
    assert_match ".kube/config: no such file or directory", tap_output
  end
end

class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.30.2.tar.gz"
  sha256 "cbf36650d5e35f8485c34ba58e1ce8e951fbda4f00c40fab687d16703b98e0b6"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd1f1d994d7c695665e3015ccf02400b817d02cba73f56f14b19b9dbdbcc89cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdd2be16d226dc74f9d64771590f001012c10442739469eed487cd3cbad3f2eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ad341e16bc4c6624f836b327b2b37d2397ce35b7b65094f749b52400ca226eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6ddee927b179a56d1baab523dcf210b0b495a7eb3793a7249ca046ed49146b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de3daa98b34991566b0ebc8c5ac888a6d0e1ca54fdfaa534c0bf1bf911875f03"
    sha256 cellar: :any,                 x86_64_linux:  "681387ff7dba66c9568937991ad9edd803cd0fdc7f2a1dae80b49bb2529c4a27"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X istio.io/istio/pkg/version.buildVersion=#{version}
      -X istio.io/istio/pkg/version.buildGitRevision=#{tap.user}
      -X istio.io/istio/pkg/version.buildStatus=#{tap.user}
      -X istio.io/istio/pkg/version.buildTag=#{version}
      -X istio.io/istio/pkg/version.buildHub=docker.io/istio
    ]
    system "go", "build", *std_go_args(ldflags:), "./istioctl/cmd/istioctl"

    generate_completions_from_executable(bin/"istioctl", shell_parameter_format: :cobra)
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal "client version: #{version}", shell_output("#{bin}/istioctl version --remote=false").strip
  end
end

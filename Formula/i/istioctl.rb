class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.26.1.tar.gz"
  sha256 "98a5ddee12d5ca9bd57a5c5fb99b5b179a9cb1ebc2005e1fac680ce8255b90e4"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "029a531d1289d425a88f9aaa84c9492c943f93786da4814e88c2c99cf3d57821"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ef66e7b5ed5cf0b127bbb0d94c0cc8988d74f044fee620914642b4f8a48666d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64a950bf512d41713972e66e2703f19d435a918378b68ab0408d7b9ae89e3021"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d4cb0174d9ab8be189343674f89e05382d8d3d2ef19d14b7b0b828dd52d0410"
    sha256 cellar: :any_skip_relocation, ventura:       "99960f2e23e4d2c5708a4fdb972c0417a04e117e1c777c24b75c5cdc9aedb050"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1486bb6f306d63a1e77a076067251a4d026d900e63b933de27ce630a10225e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "febcfe909039be1cbd29f67e6b4e9d93a9d79dc942fb8f97bac2fac26da8f285"
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

    generate_completions_from_executable(bin/"istioctl", "completion")
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal "client version: #{version}", shell_output("#{bin}/istioctl version --remote=false").strip
  end
end

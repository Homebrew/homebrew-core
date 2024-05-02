class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.21.2.tar.gz"
  sha256 "9d4e10268eca696001504482659f171a7593ab2774f913802c3ac98834bab6d8"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60b9d222dc8b951b558b13c55b374b593759067d261e7bfbbe50423a1cd3dc68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e3a94f502b0f477bc90bdfe1a78f6c036c3954f59b3dd64553414ed438440ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c21d375216e15ddc407d22c0956976a41bcdf81de50a25aa980d0720d47abb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "cbc29b231b7094e0766e5d1ff9396f03f5d35a3bc2dd7f7e29c83dd2744eb930"
    sha256 cellar: :any_skip_relocation, ventura:        "c5a61c4ed209853547d4f1d1aaa8f51bda029627124be38f15f7ba438ae5629d"
    sha256 cellar: :any_skip_relocation, monterey:       "827b55bf2772c11dc576ec7db2b6492e847d5df967f0340a13b0214c5c4d9917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31805a8bd0292478bc5182bf4efee34f3b53ea3c37f19eb1d3e50a5e5982439d"
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
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end

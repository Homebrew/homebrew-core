class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.20.3.tar.gz"
  sha256 "1e9d8cd5125372053587ce91034e963de71eb826d8274c0247bdc339415d387c"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28e271d49838e9bab6c0f8907fb1a0b18d0a7ed28cecca0a44825b14506f7c6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e786958327edc740e5331d1e861066fb3e95b228c26af7c00fe686964030057e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f42888d1cab76583f95c641adf20f238ce0b7fe384e49f0edae36c2acb1f79b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9be5638ee4aaa1115c3c901b9676c73a0c8b12abb09d0c9bbb24b7d732fe411"
    sha256 cellar: :any_skip_relocation, ventura:        "5d5d18883e83b0e0114414edc317470fc17265a9c16feba5681d02ba89aac676"
    sha256 cellar: :any_skip_relocation, monterey:       "9ca721cae5850c4f4b4e108360c7a58d78852441f80b051d8015311d06515309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fea2df57e86075364b26e7caeb71694102622f9d6fe7e4a7cfeb9d9ebb9ab323"
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

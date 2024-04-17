class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.21.1.tar.gz"
  sha256 "bff5a70e82621354db1b3a2095b4d4da6e51d5a8914b830d1c92ae530e095a59"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1c2600111d402991452937cd8149c548738eb5118fa37662c4a578c78863ddb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22958c3aac71eb6b964f020e1254cd9301aceb4374f5e48172e6f22b11f1609b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "512a7c2715ff2b43d6cb169a4ccd51d6693b6f5cbd172e80dd9648828fd9c37e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff3c5bd9f1bf3dfdedfdd024a7b9d8be9d8d1006cf460c9ca63b05a66c1dd017"
    sha256 cellar: :any_skip_relocation, ventura:        "6a46ed28cc2c17cb50b596775bcc14a0305563eb308fdc84673a5593ea0e93ce"
    sha256 cellar: :any_skip_relocation, monterey:       "0d78b6532be85b068889313f488244b0a7695da3cd3a52631b6597b93ba0bf60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b2ad7f804a95546c6d76dcff37b32bfc5f02f43f63af3e385bf8e78769e91c9"
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

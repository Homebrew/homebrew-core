class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.19.0.tar.gz"
  sha256 "7d9b78d01ac4aaf2a2c4512591314033b8a2d5e2911fab623f97ba43445181ef"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e53327d665a911cefd821db04c062d186060f7187feac2f7b932b50d91bfb49b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3f16e3b1326b8a986e23e21947de98ab4e6ab88bbf92827614390d8bcc9d628"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b82ca81361c916e5789f573f0ad628bd9a2a50c32da5e590c448304ff5b307cd"
    sha256 cellar: :any_skip_relocation, ventura:        "1b34d08f5b89ed28b22bd01416f5876edc2e5cc5e6375076f77427aa50b54747"
    sha256 cellar: :any_skip_relocation, monterey:       "9e1b1b6ae79225708a76b312bd9966a4d35b7d8b25814d4748549cfe72fa9a38"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f27fe7d574dcdbb16376758ff6aa0bd62927ea1c1370917d9e8a2b64be68d52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f73ac36574fef670c18c2d6f5eaa5af4f27ab96456a31ceaf15a0a3fc466e04"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X istio.io/istio/pkg/version.buildVersion=#{version}
      -X istio.io/istio/pkg/version.buildGitRevision=#{tap.user}
      -X istio.io/istio/pkg/version.buildStatus=#{tap.user}
      -X istio.io/istio/pkg/version.buildTag=#{version}
      -X istio.io/istio/pkg/version.buildHub=docker.io/istio
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./istioctl/cmd/istioctl"

    generate_completions_from_executable(bin/"istioctl", "completion")
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end

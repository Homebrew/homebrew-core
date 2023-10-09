class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.19.1.tar.gz"
  sha256 "d707ec7b5a557761553a4e186ad188cebd2fc95c23b8a718db48a624db9c96a5"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a91fa2f95a08d32170c276f76347c10e546827e7ef56818c0c742e5b0c1c492"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e06e8688865e46c3cfbee573d22e0d2e1f62e056fba9d7ecfa1fb81e01f3550b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85d566e8311654aec0c86c068c5f915f6c0e42f74fe42c161edd8c7e5b0b4dec"
    sha256 cellar: :any_skip_relocation, sonoma:         "43a0d6a9f2ee6f8ad0dcfbdf908c97e23aa68d6fa7ff4aff2adfe165d48f98f2"
    sha256 cellar: :any_skip_relocation, ventura:        "3650259b58e8af6ab2dd1df550ced91742b518190852f651596e3bdfb5616a59"
    sha256 cellar: :any_skip_relocation, monterey:       "83901962e501e95b6fd234e11b9c6eb44b8a1687479dc0f79533c3c491076200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17f00f9032b931652c7b8218237f080bbe91729d4a0f64b4a5a3c5708bc42e40"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./istioctl/cmd/istioctl"

    generate_completions_from_executable(bin/"istioctl", "completion")
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end

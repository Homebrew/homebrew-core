class Kubehound < Formula
  desc "Tool for building Kubernetes attack paths"
  homepage "https://kubehound.io"
  url "https://github.com/DataDog/KubeHound/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "63cb38cc12f33842a255852a45d2c795f8b20cd7de546154af1dc6a7c9fa0441"
  license "Apache-2.0"
  head "https://github.com/DataDog/KubeHound.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46205128162d5b6426da41d995af1a4b7ffc80922bf7be21d88b53b051b0bfde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4efa0e3d2f31f208b9f6362e9d5a9a45dec95f63c1cffcc627e847aad8fc428b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83b3bc446f6498809bb4aec69bd21599647b687bfe0070531d5242da25213adc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2030af4d1926d7e5b4030e2b2e50af328ebe5a9cf9f3240aeddc19122e745513"
    sha256 cellar: :any_skip_relocation, ventura:       "673c01749b813c570f2044863796057528a5f032780f2e29dfc5579328dd24d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ff86c1799aba7da91ebd19693f46c67286d75ec041bf6b0a650455e634ebc68"
  end

  depends_on "go" => [:build, :test]

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp

    ldflags = %W[
      -s -w
      -X github.com/DataDog/KubeHound/pkg/config.BuildVersion=v#{version}
      -X github.com/DataDog/KubeHound/pkg/config.BuildBranch=main
      -X github.com/DataDog/KubeHound/pkg/config.BuildOs=#{goos}
      -X github.com/DataDog/KubeHound/pkg/config.BuildArch=#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "no_backend"), "./cmd/kubehound/"

    generate_completions_from_executable(bin/"kubehound", "completion")
  end

  test do
    assert_match "kubehound version: v#{version}", shell_output("#{bin}/kubehound version")

    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    error_message = "error starting the kubehound stack"
    assert_match error_message, shell_output("#{bin}/kubehound backend up 2>&1", 1)
  end
end

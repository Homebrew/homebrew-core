class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/2.1.0.tar.gz"
  sha256 "c72753b8c030f6417033a7785fc369b822d7e51857935fd49954168b3361bcc9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc203817776de70537c9f5bc837ce459b9fe4b7ed4488ddf4f6365a88003e2e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "928f861295624df13f546b548c506d6a420db2c8470bd86d8ec4eca49a48c263"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3bc34badebe68a66f56e88579e6aa34407f7748a0ec5f8c46d3ebe4a87f2a92"
    sha256 cellar: :any_skip_relocation, ventura:        "2f0032bc16f1c3de29ab91ec6f3413c06f39f86f9c3805f03e0e6b741d564365"
    sha256 cellar: :any_skip_relocation, monterey:       "51620e87e8de1f593e518129fca034cef0e7a88e190ec3926f7a80f89dd6ca7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9a26cdf91fdab97115af4a1ac7cb1ad37972130b668dfaefcf8a0e67e39425e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74e1ba69c4bbc6f33daeddd8c32642c019e2401fa4089a0cc3971fe6895f6aa1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end

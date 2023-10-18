class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/2.4.3.tar.gz"
  sha256 "3e3991fbe076fa86e40c76f3453994b542fdb23ce5b5a86fbbd63d560a14279f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "681e5e6fcca4a96a2cb20fa2cceba271fbf2686bbffe67c926e1b807fe052acf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3126da9b07d09d399e522b062fe5618d2ffb3f1e26cab127ede30fdaa94d2f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3e54087581fd087bd7dffe8932d143017ccbe902d91acc620c849598b0478c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "fadc0f15328b38559ccdcb3288968d73c469bbffe27dfbcf941f93524c96fe13"
    sha256 cellar: :any_skip_relocation, ventura:        "b3c84c90c68442ddeea4f77601fd2bbb2ce438394002a7f5c4748492e05163d7"
    sha256 cellar: :any_skip_relocation, monterey:       "a5e6aedf987216d9aa28c66936aa3108902b9ff2345c45d31744c2348072096d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8675f54cdb3baee28773c6d1b15c074f82521c167896724642527d615a8b8237"
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

    ENV["DESTDIR"] = buildpath
    ENV["FORMAT"] = "man"
    system "go", "run", "tools/docs/generate.go"
    man1.install Dir["kumactl/*.1"]
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end

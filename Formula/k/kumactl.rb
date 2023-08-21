class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/2.3.2.tar.gz"
  sha256 "b1004314201ab58432c65546d605d24c7b391f4f9c15e7ab6d64019a0a766a32"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4d2092dec017a599a24fb4863011904ce52650b8ee05466ff9395c8c5989418"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4d2092dec017a599a24fb4863011904ce52650b8ee05466ff9395c8c5989418"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4d2092dec017a599a24fb4863011904ce52650b8ee05466ff9395c8c5989418"
    sha256 cellar: :any_skip_relocation, ventura:        "89301c130be7ea03c451c17bcf7d90f7a30ce948c3a8f2e44cc55216201cc8b7"
    sha256 cellar: :any_skip_relocation, monterey:       "89301c130be7ea03c451c17bcf7d90f7a30ce948c3a8f2e44cc55216201cc8b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "89301c130be7ea03c451c17bcf7d90f7a30ce948c3a8f2e44cc55216201cc8b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea67aa162fad274f8a9621540dacd4fa98c77ce588b6a075d68eb148419b5e35"
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

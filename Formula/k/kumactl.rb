class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/2.5.1.tar.gz"
  sha256 "57f5dab796e46a8c8f03dadeebb7b88d5b7b2d0affd4ea5ba8bda7afe7548b97"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f45f5009c5e27648e2d85236c41980d7cdc6280c9148c5eb4f847963bd2a096b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09ba15a911b5067c98f282852371d82c0c7b3f11ca4896fccf023a40990dddf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68f908b3659f56a0ff5b2c7042fc48751bfec29178c9f561af26d3cd5922694e"
    sha256 cellar: :any_skip_relocation, sonoma:         "eabfa04a4490a0612716be35867187c8cae1fd1db836d661bb88c33c2de30ce7"
    sha256 cellar: :any_skip_relocation, ventura:        "fbdf1355e056ac8b035799f52d752a2c8c780a68cf2bd3a85ee51c003fafb6c6"
    sha256 cellar: :any_skip_relocation, monterey:       "0b18706887ae844437db87ffc07ba9085d27b07a9409037edd7ebaf4b5df3fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5972f0f84c5c7b9729099c6222274c05a0f5bb3ba4d723638f27b2f5a20b3b1a"
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

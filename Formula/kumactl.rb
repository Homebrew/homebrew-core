class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.1.4.tar.gz"
  sha256 "8eaf9a7cf632efef73c0101a2ce11acb29323bb10bde4876435d98ed8c9e67a8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "950cc92a1cb226c36717a592ed9cb644bb9c3863cbcfc00b1ec443399fc2c469"
    sha256 cellar: :any_skip_relocation, big_sur:       "76a8669744149c14f90d37c48afd09b5c113308e0138569f1cd08f639653237c"
    sha256 cellar: :any_skip_relocation, catalina:      "9b59d185452ce5340f329f637aa8d88ef56576fce39fbe72dfe6b74849aee129"
    sha256 cellar: :any_skip_relocation, mojave:        "eeb940cb8abe532acb788269c8ef2c015e8a0f60014e0a0bfc295ccb2fb87639"
  end

  depends_on "go" => :build

  def install
    srcpath = buildpath/"src/kuma.io/kuma"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "build/kumactl", "BUILD_INFO_VERSION=#{version}"
      bin.install Dir["build/artifacts-*/kumactl/kumactl"].first
    end

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "bash")
    (bash_completion/"kumactl").write output

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "zsh")
    (zsh_completion/"_kumactl").write output

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "fish")
    (fish_completion/"kumactl.fish").write output
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end

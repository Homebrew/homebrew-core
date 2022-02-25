class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.5.0.tar.gz"
  sha256 "a75109f0200428d1ebba81c7f79d50cee4e91bfd3a63d92f36f0b896c52d718d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73a80a648e7cf54b1a8483fe6f845547dab2ade257f0326c50095ee523cd6f0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b46cf2a2efc3ab5f859f90261d513c3403fd35eb57c35dd94004a008feba6a1"
    sha256 cellar: :any_skip_relocation, monterey:       "bb0170cb6e06bf6ab906b5df89ea0f484091fde7773abb78b8da5f111016166e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a91a4f486ab28eb0b21d5c34f3e284ffc9c39ab95c6225ca0dc4fd33283d40b9"
    sha256 cellar: :any_skip_relocation, catalina:       "3105c31d613a79a2c8d788b2f2ddc6d449d886811cd9b6996c29aa2ff95d8ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eadb3e21314b6dd28cac7eda119bb79ca2f0bd3cdcffe6051d239a027edd5471"
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

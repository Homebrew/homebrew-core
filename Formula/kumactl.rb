class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.3.0.tar.gz"
  sha256 "46dbf50f0bd02bddfe1927b70e74676401b15362daf3cd04a36be77f288d74c2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "af500337a48e0d71d01042f8f6fb775e3acacbbfa383afccded67df8418a4f12"
    sha256 cellar: :any_skip_relocation, big_sur:       "241ff2c52fad0df096dd5acc80664c1303eea8f93c69f13b96eb1c401b1bf55f"
    sha256 cellar: :any_skip_relocation, catalina:      "29314f57a125f4df57b9ebdc7d385381f26b2e6bcda100cb5500097f3c4c312f"
    sha256 cellar: :any_skip_relocation, mojave:        "fb48f21dcb351bddf5dc97e3612041015809292f02a60704309a09cb081daacd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab73a33a9d4387172613d8abc7f9e9dab7daefadca194ef301df7394fc1f755e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ].join(" ")

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

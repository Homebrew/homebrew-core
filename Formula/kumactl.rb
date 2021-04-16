class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.1.3.tar.gz"
  sha256 "68a1ecb6c60d160d696311398b312761912f3848f64e4f84bac96d490447ce97"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a8e011758dfcd83868326a3c1fa7684f2b5c3f93df33db07d4333f3e61d729a9"
    sha256 cellar: :any_skip_relocation, big_sur:       "179a1258c908dabf17e2e412cd32120514e0258b8ac6008aad3b0623faf2d6c5"
    sha256 cellar: :any_skip_relocation, catalina:      "f147de4ba6bdddac2b3aca4fbe88c93406301c58aab61e5ace3a65dd7ae07b09"
    sha256 cellar: :any_skip_relocation, mojave:        "a007c0b8e94d16bb3b47293a6303b21082728f3291d98381814075db36b889e4"
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

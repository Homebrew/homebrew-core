class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/v2.13.2.tar.gz"
  sha256 "c31c7354412908c2e92172bdd4e132e14b355006b7774839bf563f2269b2f5e4"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bb99618860b4c625af823c6bb19cb18033413a5363e37aba670320bfa8a4469"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f095e3c2ab947b1d4b1e288adbfe14e71a5c23e786a6a80df7fb16ab29d79b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "393a1a4b28ad79c2cd978dc002b484fd2aca34de95f9f42faba406418a55a22b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fb6c546a372f8c5f16c30227d8c5b026fd2c5d6795e0e5157c960713205cbf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "586c3013ffefd9670319c135705a48f3ed85154bebfce80aca046e5fa2db6360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85b6e4fc70160d67b409c7873eba3948132c76a32e3de0770c6f774f2fae2199"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/v2/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end

class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/2.12.0.tar.gz"
  sha256 "e98fd4ae82ea3bd5fa71abb3b323959ded1db5fd383cb3ea24bb35954d0e16f7"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2032ac3a87a55f8a59bd4b4b198efa516d37c48bf0028ecd0277adbc226713d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a07e56dd01b7243a1a00f05d95ca8765c5321a78128cb86fe0271b77b6888f89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eece7b37dedc1ed432261b85678d631f1211d187ec0f748b2bc7c07e080de66a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77571bcce74294e50b982d01d23f0e06e63fdd415d0d717f33aef590ac0b37fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "40d3a03752347556474764634695fd3596ec26ff1b85a04a40ddd2f3d7edf442"
    sha256 cellar: :any_skip_relocation, ventura:       "9cd59a59ef8d14eb556690798b9edeb6d68a398ffe4e011ad62b0126af57bb84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3362602bbeebdccb0d75dd2710f10e1f64b6ae3265f15585d566887921be08ff"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end

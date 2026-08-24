class Octl < Formula
  desc "Modern CLI for Outscale"
  homepage "https://github.com/outscale/octl"
  url "https://github.com/outscale/octl/archive/refs/tags/v0.0.31.tar.gz"
  sha256 "683ad1acb62889cc9167f39ed76228bdf002fe7fb72cf1882f887228d81acf8b"
  license "BSD-3-Clause"
  head "https://github.com/outscale/octl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c974c1664d1598d0538332d0754154493f64851f66b9beb3625df95188d2643"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5847ce3c8644f8fe46ae4a80031dda566cee2ea66399ac34553b596b3fdfcdbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "271c319a32acd52d707ace4e15599caf8ada4997a984cde43c63cbd754c21a0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4efec24641e04c3024291c32db089759643fe53e4af9ae5721b6a53dc2cfca45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ac8ea737c08ec7641ecff2bf82a464177f5b68304020ab44120415fa5145ddf"
    sha256 cellar: :any,                 x86_64_linux:  "681e0ae7660cb66264776be6f316e359c96e219b9b9afaa1f8de319451f714a0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/outscale/octl/pkg/version.Version=v#{version}]
    system "go", "build", *std_go_args(ldflags:, tags: "homebrew")

    generate_completions_from_executable(bin/"octl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octl --version")

    assert_match "One CLI to rule them all", shell_output("#{bin}/octl 2>&1")

    config = testpath/"config.json"
    system bin/"octl", "profile", "add", "brew-test",
           "--ak", "AKIADUMMY", "--sk", "SKDUMMY", "--region", "eu-west-2", "--config", config
    assert_match "eu-west-2", shell_output("#{bin}/octl profile list --config #{config}")
  end
end

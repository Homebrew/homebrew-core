class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/v2.13.4.tar.gz"
  sha256 "335d4ca05d6860843a95b680ebc3c86defb862f1ac30069e380a756c3b2d3c69"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c5fc0637918bf44447de8b5c55883b5a586a3cdc08d2897122da7dc74fbc302"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb8f7f671520f3295eba96244f29f9359210f4546fb249c358233b0715d78aaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0b9e4f4707abfc2a3c8cb8de9262f39ebc10458dc2c94d65f6d577011bda4ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "21150b1a36d5460b9f8af9b6a1a27422d56e4f4eb35fe17e5675b173dea22f6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "506aca790c9acf4e2f40e51562fef302635aae3a810b48d35a0b3a9812b0c163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "068b2d0b8cd6e6b11c800c24dde459132b66e197d9f2cc498896859fa8e2a71d"
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

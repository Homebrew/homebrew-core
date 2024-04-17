class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.76.0.tar.gz"
  sha256 "60d6a80b8bfa77b6cdf3ef6eb8af0f1a23f7f16878cf2c616458e3406290eaca"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b926d9365a7d12ad13363ae1b8b3871d1e528d4ba20602e5304ddb1dc9f0ead"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfece9de851302450177617ab480235635629292dd51496dd25b8d184b7ccde6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62e97c4efe8977159a2ae8618d0e8f6ae1af0d510d88b434d17baad595a01ccf"
    sha256 cellar: :any_skip_relocation, sonoma:         "82e39c2699edcf082ed441767126813903fe7a77302759896d99651842926bbe"
    sha256 cellar: :any_skip_relocation, ventura:        "b741f443ad2119f6fd9057f865b8db60ec8990d275f6eee60a48c2523a333292"
    sha256 cellar: :any_skip_relocation, monterey:       "2d0f3002627d4d2fd9790ac11435540e2e59f1dae29311bf9a3f0554d041451f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49d9f71fc00f478fdda18b11e9e624cbbfe1cdd80631fe49cd890b13d39310af"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end

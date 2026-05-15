class Kics < Formula
  desc "Detect vulnerabilities, compliance issues, and misconfigurations"
  homepage "https://kics.io/"
  url "https://github.com/Checkmarx/kics/archive/refs/tags/v2.1.20.tar.gz"
  sha256 "7424ca07901a8534f6aa9b9d21b4c3aa873a027cf22e4bf334c5cf7fba134ae3"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/kics.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69b651845bef63ef3e63a5def6e8fc0ad5788408ed9efdc3dabe33c83d8b3efd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d958a4982aa9c912bddb6a60484241f95579cd4e91cf81ed3c288b8c167c62cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "925b758d19f6e9ab3a0fa71ce18407e84bbf1a5785dd143ec808dd102b4ce438"
    sha256 cellar: :any_skip_relocation, sonoma:        "74c888c48f65a012f9b792b6cd9a076f85e1fe9cef2bacf51ffc2be020e2da40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e1f16b9d7c4d637ceac3bd28b3441997264a21276c7c40846bc11beb25a0d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d255abf15014b2d9a57a42c7f6cd66c33d3ffdfbe64d5079653b3408149af043"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Checkmarx/kics/v#{version.major}/internal/constants.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/console"

    pkgshare.install "assets"
  end

  def caveats
    <<~EOS
      KICS queries are placed under #{opt_pkgshare}/assets/queries
      To use KICS default queries add KICS_QUERIES_PATH env to your ~/.zshrc or ~/.zprofile:
          "echo 'export KICS_QUERIES_PATH=#{opt_pkgshare}/assets/queries' >> ~/.zshrc"
      usage of CLI flag --queries-path takes precedence.
    EOS
  end

  test do
    ENV["KICS_QUERIES_PATH"] = pkgshare/"assets/queries"
    ENV["DISABLE_CRASH_REPORT"] = "0"
    ENV["NO_COLOR"] = "1"

    assert_match <<~EOS, shell_output("#{bin}/kics scan -p #{testpath}")
      Results Summary:
      CRITICAL: 0
      HIGH: 0
      MEDIUM: 0
      LOW: 0
      INFO: 0
      TOTAL: 0
    EOS

    assert_match version.to_s, shell_output("#{bin}/kics version")
  end
end

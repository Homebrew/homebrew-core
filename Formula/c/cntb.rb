class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https://github.com/contabo/cntb"
  url "https://github.com/contabo/cntb/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "4597e2c616287a1e4de66feddd73ac5feb7b9e89e756482c646c4d1e8c959c86"
  license "GPL-3.0-only"
  head "https://github.com/contabo/cntb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac6cd4334a1e67e96476b417a43f127487bfdeda97f793e7abd2cda8b205e5c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef9426c451eb50163a08bb2f0275194db90e6a560582add3fd63f45b758c4429"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef9426c451eb50163a08bb2f0275194db90e6a560582add3fd63f45b758c4429"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef9426c451eb50163a08bb2f0275194db90e6a560582add3fd63f45b758c4429"
    sha256 cellar: :any_skip_relocation, sonoma:        "f47955a60a9a69949e5a441a87de1b0ecc29fbad2b5e32a3fba24a7751f08031"
    sha256 cellar: :any_skip_relocation, ventura:       "f47955a60a9a69949e5a441a87de1b0ecc29fbad2b5e32a3fba24a7751f08031"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53157a86cb8a7c98d7400dbf0c87c726d85659ae2f1d446285c7c654e7e89d32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a72c88c25cfe526dbcac849cb91034c978c6f207588098e78440410795469e5e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X contabo.com/cli/cntb/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cntb", "completion")
  end

  test do
    # version command should work
    assert_match "cntb #{version}", shell_output("#{bin}/cntb version")
    # authentication shouldn't work with invalid credentials
    out = shell_output("#{bin}/cntb get instances --oauth2-user=invalid \
    --oauth2-password=invalid --oauth2-clientid=invalid \
    --oauth2-client-secret=invalid \
    --oauth2-tokenurl=https://example.com 2>&1", 1)
    assert_match 'level=fatal msg="Could not get access token due to an error', out
  end
end

class Gotz < Formula
  desc "Displays timezones in your terminal"
  homepage "https://github.com/merschformann/gotz"
  url "https://github.com/merschformann/gotz/archive/refs/tags/v0.1.15.tar.gz"
  sha256 "8ab6167d9a98717a8548ff60b0f454c42f116e94216e3a5d83deb711c035b270"
  license "MIT"
  head "https://github.com/merschformann/gotz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d457f2bd6b2993597ea67b8ffc167994723fe0150d50cd972c474f8520c9dc71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75ae4c58731840fe9ba17b09378742700f717d193aeeb9e532b705b78d993be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b75ae4c58731840fe9ba17b09378742700f717d193aeeb9e532b705b78d993be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b75ae4c58731840fe9ba17b09378742700f717d193aeeb9e532b705b78d993be"
    sha256 cellar: :any_skip_relocation, sonoma:        "f35197d8f5d2ebdd0fe4c50fc98508544cf6f3abff6424e57a09faf83506bfa9"
    sha256 cellar: :any_skip_relocation, ventura:       "f35197d8f5d2ebdd0fe4c50fc98508544cf6f3abff6424e57a09faf83506bfa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9267b0365ca7e9ae17f11c3cdc3b7ea3c47aaf751ce458a9549c34aeab1e7f92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a90de77faf04ceafa5b9a07dfe685ddba60dd8ec2d395e3da1b62c15230cc44e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotz -version")
    assert_match "Local", shell_output("#{bin}/gotz -timezones America/New_York")
  end
end

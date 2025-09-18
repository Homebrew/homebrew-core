class Lnk < Formula
  desc "Git-native dotfiles management that doesn't suck"
  homepage "https://github.com/yarlson/lnk"
  url "https://github.com/yarlson/lnk/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "3df383982edf86756dfc1cbbe32a98583128c61798b2d83be41c4d2253b08441"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df9b9bc47194322d14caa6523ea2eee7c66adaf9ddcae133a8163ba901b32e54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d71fc2be863d7be2913848dd5486e4b9243fbf04effa1cf809173bc1aa1fc2fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d71fc2be863d7be2913848dd5486e4b9243fbf04effa1cf809173bc1aa1fc2fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d71fc2be863d7be2913848dd5486e4b9243fbf04effa1cf809173bc1aa1fc2fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb37e958c139a758a0fd2f895a3aba48bcb7ae79f636130ee1801b3d0a26631e"
    sha256 cellar: :any_skip_relocation, ventura:       "eb37e958c139a758a0fd2f895a3aba48bcb7ae79f636130ee1801b3d0a26631e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2150e35b28dea149e41d618fee43d8d418dd793cfbcf75935768cc206248dade"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lnk --version")
    assert_match "Lnk repository not initialized", shell_output("#{bin}/lnk list 2>&1", 1)
  end
end

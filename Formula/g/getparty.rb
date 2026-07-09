class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://github.com/vbauerster/getparty/archive/refs/tags/v1.26.3.tar.gz"
  sha256 "a35626107b4217eb348cf354203011ea1e524adf014df6e59a4991d2e46a00ce"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf958266c5840e572a2709c0791c0571b6078e3dba81749ec8893ec0bebef4b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf958266c5840e572a2709c0791c0571b6078e3dba81749ec8893ec0bebef4b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf958266c5840e572a2709c0791c0571b6078e3dba81749ec8893ec0bebef4b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c83a815ac350ac6b3072e527462abcf2dbd4661c3f3dec881165754dd3bf64bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61196e5b5fe7becfcf3cc401b147cf601f37b3efaf5ad9c80029234af0126f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60b00014073e94cbdf7843af32102448ba544abd3884a60e076caed7aa8c620b"
  end

  depends_on "go" => :build

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/getparty"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/getparty --version")

    output = shell_output("#{bin}/getparty http://media.vimcasts.org/videos/10/ascii_art.ogv")
    assert_match "\"ascii_art.ogv\" saved", output
  end
end

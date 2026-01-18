class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://github.com/vbauerster/getparty/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "8f69c220d158153a9c4fb46eefcade37cdaff71954393b57152fbca93eeee223"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "830fa1ac371b12729704b955c5fa4e6103b3a618051f22aabfaa342c0bd96f5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "830fa1ac371b12729704b955c5fa4e6103b3a618051f22aabfaa342c0bd96f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "830fa1ac371b12729704b955c5fa4e6103b3a618051f22aabfaa342c0bd96f5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c700e3f01d2596b21d35d3d43d9111f2a1e003359edaf87c78668052c681efdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d2684fc2f55e4390e1a7c2cd1741058ce98f3d1bbb7888c091e5a90ed905cea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02d9d6b3d68a13bc4238ef4b7243aa21aeda321e0e51dec1a8cc29abfe08d52b"
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

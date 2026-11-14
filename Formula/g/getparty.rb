class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://github.com/vbauerster/getparty/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "ef51a575fe9ef544dab84559ddd3adb9450c02f919e842a1e618cea854380c10"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cce09a11faa55c4ad043d5033b6cf55aa9a294ad649aca79e41a64678408a4b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cce09a11faa55c4ad043d5033b6cf55aa9a294ad649aca79e41a64678408a4b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cce09a11faa55c4ad043d5033b6cf55aa9a294ad649aca79e41a64678408a4b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d2a746e1da6e47d9ab4f52923abee45b2543a7985f39d0e47d23998ca2dfe201"
    sha256 cellar: :any,                 x86_64_linux:      "0bcec58e618578021128ac6f832b26d742956cfd9ecf7a8c9777c158b08cd7c3"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
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

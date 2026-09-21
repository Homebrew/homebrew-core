class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://github.com/vbauerster/getparty/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "1dd4e69a44f5f758b34488073469a01aaefa2e82ef53a26b6b658ba35614a900"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "89510ba5ddec576961648efee8418c9ff2a2fcbfd240c2d147f192c34229f9f4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d1720ea607d150686a6f3e20993f280d8c5bc61db7ea0817cfb6223c58ad4e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d1720ea607d150686a6f3e20993f280d8c5bc61db7ea0817cfb6223c58ad4e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "6d1720ea607d150686a6f3e20993f280d8c5bc61db7ea0817cfb6223c58ad4e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6c8a6c5334ed84a351db3672dc5e6198f5c905596257879cd8c702d69bd74f99"
    sha256 cellar: :any,                 x86_64_linux:      "770ca9fb8583f05acd5d478aae96d400e01402b5762b7839008f5607e6fd85dc"
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

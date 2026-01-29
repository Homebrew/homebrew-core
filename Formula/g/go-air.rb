class GoAir < Formula
  desc "Live reload for Go apps"
  homepage "https://github.com/air-verse/air"
  url "https://github.com/air-verse/air/archive/refs/tags/v1.64.4.tar.gz"
  sha256 "69c0dbc71d434203c99ae41155ffa5b0a1e46699fcf4e2d14727d429ce290aa2"
  license "GPL-3.0-or-later"
  head "https://github.com/air-verse/air.git", branch: "master"

  depends_on "go"

  conflicts_with "air", because: "both install binaries with the same name"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.airVersion=#{version}", output: bin/"air")
  end

  test do
    system "#{bin}/air", "-v"
  end
end

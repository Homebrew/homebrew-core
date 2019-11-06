class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.16.tar.gz"
  sha256 "e1cc35c471b06e12580344c15f30c49b161e07a4c900401372024f141d96646d"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c563d3742b5ae012b0c08f3e816f04092c3ba5f3460b046790d5b8c12d5563c" => :catalina
    sha256 "d0484ba43d434d973d2fe02689b8d33d8402ebd2931c84c44317841a214c8abe" => :mojave
    sha256 "c1f265ccffd84dc3077f6eccf68d1e71430b2a38401ce58ee572e228b070730a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/barnybug/cli53"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"cli53", "./cmd/cli53"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end

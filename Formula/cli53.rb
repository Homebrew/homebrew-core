class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.16.tar.gz"
  sha256 "e1cc35c471b06e12580344c15f30c49b161e07a4c900401372024f141d96646d"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c2a5dd44af517c69efc330c702059b7796d2fd0b4d2fa648eda6dfaa14485c8" => :catalina
    sha256 "8b2b742de7a1c984e9f89feaf08fdc51c0e33de1b85756309d3d01eee6f1cd92" => :mojave
    sha256 "c4bb7bc057db2d1eb5d1d1db7b9bc12ed84d35fa66af7876cdf1b6ab70196a24" => :high_sierra
    sha256 "8ff45dc92eb907700f61b4c7142cf50be6c1f7018c2e62a08d4c522c5ecfe047" => :sierra
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

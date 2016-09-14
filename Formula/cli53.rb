class Cli53 < Formula
  desc "command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.4.tar.gz"
  sha256 "ab57119af8e0f2af67616ef0d860ef055a97c077447fe5740c7123b2890cf6bd"

  bottle do
    cellar :any_skip_relocation
    sha256 "f88d0f3032eb57d7c497c1bd7f832086e75ea5c2fa31e9aca1647133cbd37470" => :el_capitan
    sha256 "be71e291ee081da119cb2ad70a0d04d59758ba865cc1a4f1dcaca21feada611c" => :yosemite
    sha256 "52751c6af46b030c3f6ca4c9c6b652b92cf7a9979726e4ab3bb5ef2d3d42436b" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/barnybug"
    ln_s buildpath, buildpath/"src/github.com/barnybug/cli53"

    system "make", "build"
    bin.install "cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end

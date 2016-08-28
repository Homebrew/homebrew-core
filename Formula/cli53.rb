class Cli53 < Formula
  desc "command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.0.tar.gz"
  sha256 "1efd7b951a74ccc31b3392e19955eaa8c336b35815e24118103155c5b4a9a4a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "816913c8710a53aa78ff84c1d3daeb455907567d1f0143c5dc05f5aa05abf4af" => :el_capitan
    sha256 "75c198e58e535d3fa7cb6a1fdfa68d948db3beb1f6a2d4f87cc04576cf5f72a2" => :yosemite
    sha256 "4eae024f56873526a9715c7ac880a837602e310c7c52f72769098f990d303b17" => :mavericks
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

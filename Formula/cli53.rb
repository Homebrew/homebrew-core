class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.15.tar.gz"
  sha256 "6b9fcce93071782f9cdfe1a05f098aa08e83f317a0685c2a7f09bafb7d74d24f"

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
    mkdir_p buildpath/"src/github.com/barnybug"
    ln_s buildpath, buildpath/"src/github.com/barnybug/cli53"

    system "make", "build"
    bin.install "cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end

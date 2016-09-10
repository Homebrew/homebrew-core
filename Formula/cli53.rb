class Cli53 < Formula
  desc "command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.3.tar.gz"
  sha256 "e87225714a42801dcbe96a1ebe12a841315c7db2eee992d7eddef18827469e7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "8527b915200bf4ecf957c0695f18c909eabf99b8699453268dc465efeed4494a" => :el_capitan
    sha256 "f979d84645fe43b51de6db1d268ab2f687523413d5d7f458bf965911ecc37d1e" => :yosemite
    sha256 "c7443e2999db2eb176473693db22874034d2f743834c818c89848d801afca5a5" => :mavericks
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

class Cli53 < Formula
  desc "command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.6.tar.gz"
  sha256 "be1f97cf892c453410da69daa16141964d9fac6557447cadb0cb613ffe341c59"

  bottle do
    cellar :any_skip_relocation
    sha256 "13ff90b5de6883f7713b5285ee43fc9c24bd3a101dccbd6b16f8b7a676b5a3dd" => :sierra
    sha256 "971739862970057906cf8f9dcec332d7ef2ac8afa5cea508a3f6d8c339f9fe7f" => :el_capitan
    sha256 "f1d457a3fbd3a9b9a8935726165ea04b5ce5c72f28fb0a12b34343396ef00e14" => :yosemite
    sha256 "763bb87f2a16121b0b1bb0b6fd9068f0efc63172807a6cd774ecef9f7a084088" => :mavericks
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

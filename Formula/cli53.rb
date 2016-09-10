class Cli53 < Formula
  desc "command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.2.tar.gz"
  sha256 "0a9999f3e40f510d6d6faa01b64cefcd5a3ddeca1f785a25ede568f440d100bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "99cc44d91bbed5282c6ccbbe7c0613e343495838c2fc6fd7cd4dc209b6f2f093" => :el_capitan
    sha256 "77febccd0665b60dec469e323d5556c67c011b5e685b01327869c1d5f355bb0d" => :yosemite
    sha256 "0f0b0b26685886897ee7910ab24d298a95c5631ea76473674a9799ca960f46d9" => :mavericks
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

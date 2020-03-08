class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.17.tar.gz"
  sha256 "32b8e6ffe3234f87497328285c377b9280d1b302658e9acb45eb0dedbda0b14d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1dc8fc0a54263784bfed7d0ff6802ef66ef753d276410be52f49620b1bde89ad" => :catalina
    sha256 "9d4dc2fce304be814b276f23415c736a426011642609c6625a45181b3a894857" => :mojave
    sha256 "a9cdffb7125145c1d86e6a9bb3f75049254a66168ef41387cf25d98a253d0756" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"cli53", "./cmd/cli53"
    prefix.install_metafiles
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end

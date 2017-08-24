class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.9.tar.gz"
  sha256 "a6ab5c79b1eaae83dccb9c8892cf207dd7756bb0c0be6a3fce8b3efc92544768"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2f802184e6eee8afcfe0236ca1585696cbbfe3f0fe57b74f764259efa08a624" => :sierra
    sha256 "b67c09375c0204a67491768cacb2737ca029acd0a1a036545e53ca862555fc9b" => :el_capitan
    sha256 "8ac4114d56b3632543fd646d3dd4f3e5289e79a719c9e756ae9baaa8d2d94042" => :yosemite
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

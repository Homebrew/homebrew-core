class Ironcli < Formula
  desc "Go version of the Iron.io command-line tools"
  homepage "https://github.com/iron-io/ironcli"
  url "https://github.com/iron-io/ironcli/archive/0.1.3.tar.gz"
  sha256 "7fc530da947b31ba3a60e74a065deac5a88cb1a4c34dc7835998645816894af1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f329dac399b4e91562aaf13592dadd94fcc2f6d94f3ce09fec1e46a160a64a27" => :sierra
    sha256 "f4a49366543c6876ef16fd3cbe4c123255f4b68db200be460d9a277771e8d40c" => :el_capitan
    sha256 "4d57b9a215dacf866ab2a06cb8468a99de7aace1c8b2d0deaf3239879959716f" => :yosemite
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/iron-io/ironcli"
    dir.install Dir["*"]
    cd dir do
      system "glide", "install"
      system "go", "build", "-o", bin/"iron"
    end
  end

  test do
    system bin/"iron", "-help"
  end
end

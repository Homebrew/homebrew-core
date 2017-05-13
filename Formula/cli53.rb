class Cli53 < Formula
  desc "command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.8.tar.gz"
  sha256 "31c4dcd25c0fa514d6d02f5668bd55295ec2d5c07ee3e2e5219034b9bbc3d37f"

  bottle do
    cellar :any_skip_relocation
    sha256 "6aa4ee2ea255b29602d99f548d1f9360de782494a3d62cee1f99b887fd7b6bec" => :sierra
    sha256 "0b1e904823d61ab0c8a4ff282eafc39c4a3d194f5db78a7ed1b7127839937382" => :el_capitan
    sha256 "88580ed525f8b9462d85011f503541bf29bf13563fe096983c76f1806f62aeb3" => :yosemite
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

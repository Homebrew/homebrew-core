class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.108.tar.gz"
  sha256 "3ad7d62e25920c1c04ca6f73f10e8a28a34bb93c1b90e75b920d372843649906"

  bottle do
    cellar :any_skip_relocation
    sha256 "69f1bd5941cebeb6aede2cd82d00aa26ec68b7f08dcf58cc3441461142909408" => :sierra
    sha256 "ff15650f932512e53b9e0787042777d7a5df4d505c3cd963b81fcab7332952f0" => :el_capitan
    sha256 "e79903e992601c960e1302793d116d64553ebe91e67a3ed262658f2f4081bd7e" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/fabric8io/gofabric8"
    dir.install buildpath.children

    cd dir do
      system "make", "install", "REV=homebrew"
    end

    bin.install "bin/gofabric8"
  end

  test do
    Open3.popen3("#{bin}/gofabric8", "version") do |stdin, stdout, _|
      stdin.puts "N" # Reject any auto-update prompts
      stdin.close
      assert_match(/gofabric8, version #{version} \(branch: 'unknown', revision: 'homebrew'\)/, stdout.read)
    end
  end
end

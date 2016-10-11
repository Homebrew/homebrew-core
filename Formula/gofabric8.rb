class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.78.tar.gz"
  sha256 "f3b898d979837119b42f7a938ff201719c41691afebc40eb58e905f34806a7e7"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c0e1460853688bab0a42b0dc95e5e4c3e52ed0c04d494b7e45d77e822b3cb71" => :sierra
    sha256 "978fc7003b66a50d037710acba6579d5cbfa39e2141d571a6261aed50939369d" => :el_capitan
    sha256 "38e2f41c21b506f540fbb3845800f85f55359f690728a7a9d05e817eebaa6a77" => :yosemite
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

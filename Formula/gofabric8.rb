class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.153.tar.gz"
  sha256 "265406517c9a0ab1c8e150560ba97dd4ebe8db063aaa8e57a512beb5af2a1d15"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea252ed3cf0d0e43a832e4941d4ed4a3474d287f34fc54dd4189b72a24167bd4" => :sierra
    sha256 "c46d9f376ea54f86d5aef41670fa8afafa02988915e528b7dec70a0dd1952503" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/fabric8io/gofabric8"
    dir.install buildpath.children

    cd dir do
      system "make", "install", "REV=homebrew"
      prefix.install_metafiles
    end

    bin.install "bin/gofabric8"
  end

  test do
    Open3.popen3("#{bin}/gofabric8", "version") do |stdin, stdout, _|
      stdin.puts "N" # Reject any auto-update prompts
      stdin.close
      assert_match "gofabric8, version #{version} (branch: 'unknown', revision: 'homebrew')", stdout.read
    end
  end
end

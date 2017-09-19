class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.156.tar.gz"
  sha256 "8abc2d66eb0cfd7b09a88fb7981ad053e6d714f86caff04bed5df96b8aacf0f1"

  bottle do
    cellar :any_skip_relocation
    sha256 "82ba67017a8db160942f0e66510c20b3df8cb1679bc373905113843bddb48494" => :high_sierra
    sha256 "337679b1f39c62208a7c91b77c0db553afdc907e52c3611bbe0f59cd340c780d" => :sierra
    sha256 "4df94341a4735901934da903e21144b9aef5723e76f91f07adbda9e5f82c48fd" => :el_capitan
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

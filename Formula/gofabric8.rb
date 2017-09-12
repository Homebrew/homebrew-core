class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.153.tar.gz"
  sha256 "265406517c9a0ab1c8e150560ba97dd4ebe8db063aaa8e57a512beb5af2a1d15"

  bottle do
    cellar :any_skip_relocation
    sha256 "55712c605622f4e5ac5176eae968709bd007bcaac46376770ae3f6c4041e4d8a" => :sierra
    sha256 "9bcba697608a9d802dca220305b8676c82e5159ae49d54001e217400c8af3af0" => :el_capitan
    sha256 "97246d3cde0c3d53ce70d6a177cccc7d5bad3d6356e8012ad76368d08b8e5d47" => :yosemite
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

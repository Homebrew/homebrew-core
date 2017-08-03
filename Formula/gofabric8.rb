class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.139.tar.gz"
  sha256 "701e41ab0051d9d318d7556654c15e8ea1a808d2578968991ded59dca2fd5ad5"

  bottle do
    cellar :any_skip_relocation
    sha256 "c110b4445e4d262bcf82d61975b70b05fa4ae3a9f5cd772c28e85d1e91781891" => :sierra
    sha256 "69692f745687553228168c0b1390f9ece58fd012894d5dec0eeccf326b67d16c" => :el_capitan
    sha256 "2a09fa9b61b199b9d84249285d1934f6e636eab6edfb796bd923c39ff198c8a2" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/fabric8io/gofabric8"
    dir.install buildpath.children

    cd dir do
      system "make", "templates"
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

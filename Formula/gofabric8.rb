class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.162.tar.gz"
  sha256 "e1eee26bebf4fa4e0d499d228cd80ec22f17ff2eb7a24e10d2d040e3878b205e"

  bottle do
    cellar :any_skip_relocation
    sha256 "d552fdd8012ca37c45c5b66500cb13b183c6956153d328fff6785d5b29a0085c" => :high_sierra
    sha256 "862b99895633639e0a13e29a4a61130f6be63a7d4daa3b065ba28f8f853169a2" => :sierra
    sha256 "59ef19ca74488daf6f22aad80cb6a7309a054c7e9add083673012b4f7e95d69a" => :el_capitan
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

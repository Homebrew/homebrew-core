class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.157.tar.gz"
  sha256 "0fe0ff370fe4074cffa676b1b92ea1ed36610b9bfe4c24334b9173ba9aa6fecf"

  bottle do
    cellar :any_skip_relocation
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

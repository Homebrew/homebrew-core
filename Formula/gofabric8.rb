class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.134.tar.gz"
  sha256 "ae16da5acf9f5207335146c8804a86dbe728cbe18b7d63a5426e24892d188c7d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4fb00136b487b9f4c4af7e0c34fa649407762c1720b3333978ab3f9e75690a4" => :sierra
    sha256 "ba98e8e677187d354f7780ef5ed4949519756b02214e5c651c2607fdae1db32c" => :el_capitan
    sha256 "482450a511e4b76b75c985688b56eb73695809c2600de4322fb46c2edc970e5e" => :yosemite
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

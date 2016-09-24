class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.71.tar.gz"
  sha256 "4eacee14e73056933dab263918cc64e45c57a2c7c7575fd23dada2a6ff3c5fe1"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    files = Dir["*"]
    mkdir buildpath/"src/github.com/fabric8io/gofabric8" do
      files.each { |f| mv buildpath/f, "." }
      system "make", "install", "REV=homebrew"
    end
    bin.install "bin/gofabric8"
  end

  test do
    system "#{bin}/gofabric8", "version"
  end
end

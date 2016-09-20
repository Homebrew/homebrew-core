class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.69.tar.gz"
  sha256 "21a34018367d8aeb9446be23747ff918770d0c8e827e7d3e0b7a57542eb61274"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    files = Dir["*"]
    mkdir_p buildpath/"src/github.com/fabric8io/gofabric8"
    mv files, buildpath/"src/github.com/fabric8io/gofabric8"
    cd "src/github.com/fabric8io/gofabric8"
    system "make", "install", "REV=homebrew"
    cd buildpath
    bin.install "bin/gofabric8"
  end

  test do
    system "#{bin}/gofabric8", "version"
  end
end

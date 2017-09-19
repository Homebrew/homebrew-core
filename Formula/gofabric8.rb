class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.156.tar.gz"
  sha256 "8abc2d66eb0cfd7b09a88fb7981ad053e6d714f86caff04bed5df96b8aacf0f1"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd1f99d9c680cb1b0c3a3699ac9ca3d62cafe2bf1d8ff4dbb301ab890d89355d" => :high_sierra
    sha256 "71690ec340545327d445bfecf64d397616be5134269953a97856c69b882808e0" => :sierra
    sha256 "c00c0d46784088523b77eb7558863483b80ecbb1e58463f6059bd3ccdfb4d322" => :el_capitan
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

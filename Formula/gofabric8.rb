class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.154.tar.gz"
  sha256 "bef8e6ff91d5e7a69a66ae2fd3bca9df6b5a28159addbb705c8d614550290304"

  bottle do
    cellar :any_skip_relocation
    sha256 "c531d734b0ba04c42cbea4981e7c3eb9b710b3f7530029d0f0135fdafa377df4" => :sierra
    sha256 "65a93b3f34c56dbbaa18f5774fee17a0165b15bfdc5e43004c6f8738ce10d7f8" => :el_capitan
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

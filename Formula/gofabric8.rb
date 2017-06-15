class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.131.tar.gz"
  sha256 "73ef1f3fe5027014df7c77e67071f1426fbdd8b4ce20c603020aaa6c4a7d7fe7"

  bottle do
    cellar :any_skip_relocation
    sha256 "8652c2bfba515363a477f36a354ae815dfe7e18e9536a7143a3851a09d353f3c" => :sierra
    sha256 "52b94534658ed72a804adad68b725ef0f0853b54ad47bdec5ee37f3be1b5c116" => :el_capitan
    sha256 "429d4d90d86cd682806855c2f7def59a0fc1dc18713e9552a6fb17ebbfaedfd1" => :yosemite
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

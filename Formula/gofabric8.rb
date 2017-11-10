class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.176.tar.gz"
  sha256 "78e44fdfd69605f50ab1f5539f2d282ce786b28b88c49d0f9671936c9e37355a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f398cc6a96d5b20bc206169c4f521a3a0a40ec65797d165f9a090f292ff246ad" => :high_sierra
    sha256 "40f861862c096e274b5fe84e48dfdf27ca206def6de7ac8734930c34f5e04b5d" => :sierra
    sha256 "51d55fe260aa791bf93068a9e6e22561f4437562160c1133463c0214c26c4dca" => :el_capitan
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

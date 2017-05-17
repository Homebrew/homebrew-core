class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.123.tar.gz"
  sha256 "7b7e2989de0065c3eb4dd63d593c21dc6de76b2446387fb39674922e44eef1ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "5921c2b84d4c4235d99db7aa96a092e9bcec9aefaf802f7035114ad747c3dcc5" => :sierra
    sha256 "7d2aeb05f47a95225e87b7aad33eda9db014fb0a76b807edf463dad1fa2053b4" => :el_capitan
    sha256 "a2102674d1bc735c570a8583984decae6ab93359e3b1cb1a921699042e7f2945" => :yosemite
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

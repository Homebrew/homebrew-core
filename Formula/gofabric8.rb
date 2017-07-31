class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.135.tar.gz"
  sha256 "9f07b550919e5a95767dc275765c0a0794df7a39983e7737647c0442ee3537a7"

  bottle do
    cellar :any_skip_relocation
    sha256 "6cd765e5316d212b2bcabe0c987f824ab8a485b1e2a164c496e6b8d92a01488a" => :sierra
    sha256 "4fe6818bb4ba59ba7b7eb4862d4b1395e0cef5bdd4599e4bb2b077e7edd5b316" => :el_capitan
    sha256 "db999276f78e8e376fa1822a77bce9655e7b4d7204a8f28f2a6989c2e490e29e" => :yosemite
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

class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.133.tar.gz"
  sha256 "cbe44cf2780f5248739f51f1e8221142e8fd488ed5283185027a713fbab18657"

  bottle do
    cellar :any_skip_relocation
    sha256 "7041cc312cff082c193835783c3dc20b52c046b34cdea37ad4952f2bd735da66" => :sierra
    sha256 "e52db04fe67d35c676a1fdc0229895be3396b36c3382d9bdd1ae679cc6008532" => :el_capitan
    sha256 "f29b449e30e2e13a974017a0d2b6b294c1f99f63ca4c29453be52064caaf6ece" => :yosemite
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

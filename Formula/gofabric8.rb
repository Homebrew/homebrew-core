class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.138.tar.gz"
  sha256 "6d0014e0d068f0b1392645ba86456bbcfa74e55dfe58bdc2ef940152270d6eb9"

  bottle do
    cellar :any_skip_relocation
    sha256 "84cb49a95b066329c2cab8041445a89e90c9529dff08d2f614c363d5ca26738a" => :sierra
    sha256 "0f45e20eb6b5ddc4adabbbae0daeb145e425e35c61144f168eabc4b9a7501a46" => :el_capitan
    sha256 "792a603074f0e010f141f9c652a6362521c6a573c335cb0c4b8c55f6b76ce2e1" => :yosemite
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

class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.173.tar.gz"
  sha256 "a9a084301f5d3b27bb17a79e37800e28ef32cb260c4e5dd0e6f48b8d2ddc0133"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a66bb1b8ece794bcbf439704dd7840e6a6ea5e6282e6b8bed9c44bd7de970fa" => :high_sierra
    sha256 "492ffaac75766edd49075c725dfdc5df4d0fa6df6d74c41f704a54df254877c2" => :sierra
    sha256 "6f188dae8aebf49099350df7082fb162ed349d80517a51b44d449637bb59437f" => :el_capitan
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

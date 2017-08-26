class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.149.tar.gz"
  sha256 "f463d584a6ca93560ccb6e111587e84f28a837cbe09f40b379e6131ae66c81c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "dac0ff4870e3f666fb9d1ebdd602a2be2300a0f17801d6ada1a1377ec5f0d6ae" => :sierra
    sha256 "5a525878b568b52def85ddd30bb1658c62c0af43bba63b84f6ae588871787c85" => :el_capitan
    sha256 "f43476ce4fe0730dd3cdb51985b803140119e839b0fc597926616f5d17bba6c7" => :yosemite
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

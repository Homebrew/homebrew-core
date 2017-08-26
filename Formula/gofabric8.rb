class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.149.tar.gz"
  sha256 "f463d584a6ca93560ccb6e111587e84f28a837cbe09f40b379e6131ae66c81c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f4c6b392f377fa91a683692fc0a834ec50603bf20adf621f0ae74316b8725b5" => :sierra
    sha256 "f25d3d9c1cefb6d80169d25cdb6d3c53a533603acc4697d4cf5670048329ee3b" => :el_capitan
    sha256 "bab0cafe24f8a1f7c0d11ec9ad0126199ab78c0e37f67a4e11c0f3aca0bfac62" => :yosemite
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

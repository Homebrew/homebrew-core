class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.122.tar.gz"
  sha256 "ab9e0ba8ec19e8156f13d191f84546209eba8b8fc1e60ac716eed407a63384ec"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f5d5bd9d12dce12f5f6eada726000fdab2068a410dcaebf179752ead28eaa9c" => :sierra
    sha256 "c90a08ed921669235f5db4a18784ad561f330e3e40b71f8a37b6302cd072955a" => :el_capitan
    sha256 "5ecd0b6ee64612bc0985ef8e7921c35475c62d3b50b58b916adbfc0337b676af" => :yosemite
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

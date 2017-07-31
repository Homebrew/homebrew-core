class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.135.tar.gz"
  sha256 "9f07b550919e5a95767dc275765c0a0794df7a39983e7737647c0442ee3537a7"

  bottle do
    cellar :any_skip_relocation
    sha256 "1825f82593f14a31be3543fe3f3e1583dff842dfa07255445aa43bcb45fbf2fd" => :sierra
    sha256 "bc75cf04c61ed57fbbcdaaf20fc4db1a27fe01c665f5127d66776697ee3c3ee1" => :el_capitan
    sha256 "8509bd28aad102596dcb54982cfb89d1827a77bb4c20d198b11997f384f840e6" => :yosemite
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

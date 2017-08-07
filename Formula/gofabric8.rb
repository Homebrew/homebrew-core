class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.143.tar.gz"
  sha256 "545616df1bdac5aa2039830d224fdeb5b6eda69f01340de251400412f84c8399"

  bottle do
    cellar :any_skip_relocation
    sha256 "a924948aa65c49ca1086fad42a1cbf79045b15adedb7bea2e38db88d81e5195b" => :sierra
    sha256 "0228b1db0d3ea955a8beb6db8ffde445599443d7779488ad6e5c428b6b87c3d5" => :el_capitan
    sha256 "7feca3364c5669a48bae32a4b7b94b339868867b09721bd3bcacd93a66f2818e" => :yosemite
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

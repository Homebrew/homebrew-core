class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.146.tar.gz"
  sha256 "21320543a219997b27bd864a9600e50ec60a9e7bd27f0a95407c095d6389814e"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bbe85544df0ac8115000df75f42f24efc6ed3deb31cb56928f5406dc6f8e862" => :sierra
    sha256 "f32ef6d860c667af8e6fde82c403a028821f8c43addc4b3ca734dcc053b0e55c" => :el_capitan
    sha256 "a483b3568cd6b287e3081d15f33f36e98ee6674bb1045764b2304715636fe149" => :yosemite
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

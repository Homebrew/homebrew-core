class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.138.tar.gz"
  sha256 "6d0014e0d068f0b1392645ba86456bbcfa74e55dfe58bdc2ef940152270d6eb9"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d624fef41deddc51dcac3b91d4d68191efa6ea2fba417b73bfd0657e081bd42" => :sierra
    sha256 "f2f3345fb7f232d3124e153eb157157487d368444b3d915669a4754fdb5fa971" => :el_capitan
    sha256 "f5f52992d2832c1ac35b8136553b37ce9b1f78b1c41ccdac989d65e091e55294" => :yosemite
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

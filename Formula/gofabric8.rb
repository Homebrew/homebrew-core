class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.103.tar.gz"
  sha256 "9403171188d8ae5210d7469d56e42a45e812e88ea8c567505be887453c0d17da"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9dfbad2c2a23c4e5772207ca12af296f80003c2621bea8c5e32100d56322d1f" => :sierra
    sha256 "0305a19fac3e10e23d9f6f28913c299b3c97772bfdcc90dc68ab0d75f27d0d60" => :el_capitan
    sha256 "13e1b33ce893c80ee1223507a1f2d402faf800142411b0220febc3e171dfab0e" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/fabric8io/gofabric8"
    dir.install buildpath.children

    cd dir do
      system "make", "install", "REV=homebrew"
    end

    bin.install "bin/gofabric8"
  end

  test do
    Open3.popen3("#{bin}/gofabric8", "version") do |stdin, stdout, _|
      stdin.puts "N" # Reject any auto-update prompts
      stdin.close
      assert_match(/gofabric8, version #{version} \(branch: 'unknown', revision: 'homebrew'\)/, stdout.read)
    end
  end
end

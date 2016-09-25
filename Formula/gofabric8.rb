class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.72.tar.gz"
  sha256 "0c082072fc9731fc939b6d4b6719adf20e0e69ff780d613337e1832ab9e8a1db"

  bottle do
    cellar :any_skip_relocation
    sha256 "cdde1f0c4aa384079019275992e3668dcd99f476e9351ee4d6d3842e0feddc96" => :sierra
    sha256 "21713624cd81338006ece77271b5b3f907827925eb2a25a4cd9ee8db11c90775" => :el_capitan
    sha256 "cb407cec9ce4c68abd03a7c03b05bbcbe170d7fc8c02f47cb1f4a663772deee9" => :yosemite
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

class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.113.tar.gz"
  sha256 "1951e3efee4a375716980d70ccd1f7aa7ee9beee95cce1c8c2bf1622d0dd6bfd"

  bottle do
    sha256 "ad7678f9c1b76a985446ebb8ff01fb1a434ccfe8debfcd565c6811d8e661d680" => :sierra
    sha256 "72e455047f2d6bed27a0f2a2f4b0214d16a4f0c17f0a523039d1af89de9824c8" => :el_capitan
    sha256 "4988a3e6ea6acf1677c76845b51ca734e0ad5c1113f4e80d80c0c6930ffb71fe" => :yosemite
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

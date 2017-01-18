class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.113.tar.gz"
  sha256 "1951e3efee4a375716980d70ccd1f7aa7ee9beee95cce1c8c2bf1622d0dd6bfd"

  bottle do
    sha256 "54dc8892e12562449cd84a7d13c412dfc7d0f11966691135f7885a7ab2a3a8a1" => :sierra
    sha256 "5b289f6e81ca8e612b2ed6b20f1e3f02bfcfa6a75df3f4ffc12908713bb7ae41" => :el_capitan
    sha256 "8aa6ae13e8cbefd632d6ad9cd6d93800aff3d09749331b5ee02907176b080b5f" => :yosemite
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

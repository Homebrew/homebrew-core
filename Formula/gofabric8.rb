class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.121.tar.gz"
  sha256 "9fc6656150e84d469ad9f37cf0e43b2afa146acb4d9f92e7de368ea7ac9075e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "efff31855d234d066415c328eea8283e3981cf5a5e2ffce0fd397a46a6f02a71" => :sierra
    sha256 "086cce8d51f4f848b38cc0cad2cef76b9f7361d230860f6653e7e10bb15a3591" => :el_capitan
    sha256 "ce3f15851ccde3aa46ecfe7483510bc9fc679d71800cc8c55724483be0b38d87" => :yosemite
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

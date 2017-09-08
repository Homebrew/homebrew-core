class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.152.tar.gz"
  sha256 "202fe6c5e95b9edbd15795c7aa9e6fa37e257d081441c3275aa814bc055418ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "280f4ecc6b38bff0fae0fc3e12c6ecc4e1e057722b697277caaf073fc6400326" => :sierra
    sha256 "f11b245055eb7a424d77641db1ee0aca33f94d8e73d0ed8addc1f35676ca2f4b" => :el_capitan
    sha256 "80a571d8ec6400c381b6d3eb4ac8a2346386b859a23635a196dfae417059ac4d" => :yosemite
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

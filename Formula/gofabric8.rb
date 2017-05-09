class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.122.tar.gz"
  sha256 "ab9e0ba8ec19e8156f13d191f84546209eba8b8fc1e60ac716eed407a63384ec"

  bottle do
    cellar :any_skip_relocation
    sha256 "374a5757c1c3f8ef4531d9d921213c211ac9a863f48c301959cd4d69d0436c0f" => :sierra
    sha256 "ec4feb35e586cfb5b67a51aaf5adda167a6732d4bc267c8d6fbb1e676eba2b6b" => :el_capitan
    sha256 "8077f8bf1027d5510475ea1c38a2719954092ba2c715efc446ec823d3a6ac8f0" => :yosemite
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

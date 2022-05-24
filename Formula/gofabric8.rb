class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.176.tar.gz"
  sha256 "78e44fdfd69605f50ab1f5539f2d282ce786b28b88c49d0f9671936c9e37355a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc81a3d411740c59daa6f2130871e78b52533709c0eccdba91b5ac8b98d283ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33dd12b78757e29d078afe1fbb57fc4530c71f804f88c96ec48452f8b2053ad2"
    sha256 cellar: :any_skip_relocation, monterey:       "07d4ba74501720a1e068a62afb148da767c509c72f0ab14ba3ec22349d6cfd73"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d4236c764b54c4699ceaf07831bb6fcd5709e99b343c8a2b5288ff3faa40f94"
    sha256 cellar: :any_skip_relocation, catalina:       "6400faecf5cfe3dfa54a04839869d327cc3f71d586aa5740d9f63e1e1f13c5f4"
    sha256 cellar: :any_skip_relocation, mojave:         "6fefb818e47769d4c0811db307d5000aa7d3d48bcdae42e24b0a27272e01641f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1bfb6f211dbd423cf15ea057c94f42afab57ec7b955b33057086dbc84b2c1f9"
  end

  deprecate! date: "2020-11-27", because: :repo_archived

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
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

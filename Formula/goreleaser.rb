class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.112.0",
      :revision => "aaa39e98c922961186151719fb81ee9a3447b7ff"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e6bf760ed42023cb4f30fefb81a74d44ae38a953f7c158fea2118ebe465dd06" => :mojave
    sha256 "f2da347f931cc39ceb4d30ad3d35330283256def936e7f2bd45cad197ab4bf6c" => :high_sierra
    sha256 "33451401a27a9bb440f4ba87007612c1682c90a1ef48a0cb43038d3b32234931" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/goreleaser/goreleaser"
    dir.install buildpath.children

    cd dir do
      system "go", "mod", "vendor"
      system "go", "build", "-ldflags",
                   "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
                   "-o", bin/"goreleaser"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end

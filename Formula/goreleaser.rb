class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.109.0",
      :revision => "7ee486fc9b58171e70eec99ecdbeac4c99cc82d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2238678decd3237868caefd21c4b3849b0109b60d165839d17d1a16361fdea7" => :mojave
    sha256 "6f97eee9fa9227f65bd64545a860319f4e6e2f43ee63c038e30fabe6b638a9b3" => :high_sierra
    sha256 "0b70f0a3c35758a803fec463177b46a20438aeb263dba35b829f2b5c354b0f3f" => :sierra
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

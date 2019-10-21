class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.120.2",
      :revision => "449ed95bbe73fb88159e061352fcc786987d7d7d"

  bottle do
    cellar :any_skip_relocation
    sha256 "02c66e12da00a972d55a3b7c909347a62185ecba44edfb3f9e63baae6442918f" => :catalina
    sha256 "4d2475536aa96bc45953a19025aeca8b5df300ab1a9715fad44a427b3c5d343e" => :mojave
    sha256 "111189707e4f9e63f9aaace3798fb4f9b3cd947291571e13c90d006aebba1cf0" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

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
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end

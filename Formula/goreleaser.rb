class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.119.0",
      :revision => "39d07c375df531aa0c55df868d26f8dcc4bf37e1"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf151f33c5dcf7ae94aabcacf42c54ee0c5cae5966632b5780763f12bafefb29" => :catalina
    sha256 "7808cd4f601a22861cdba6e0f2550c75648f33d0baa8a1e7dde8c3a775a22c6f" => :mojave
    sha256 "51057fc46d59ff61d7d9537be46289d4ff44bfc81029eb308eec980299d8f24e" => :high_sierra
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

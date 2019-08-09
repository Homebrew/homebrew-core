class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.114.1",
      :revision => "36b190490f7b1716c9edb9ce96f243397b97abf3"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f1a943d8fe6b99c55eae523e090be1670081549db431f3f24907507a972df96" => :mojave
    sha256 "1aa12886cce135e925534c769feddd565e6361126c266f29019fd93c2a552fef" => :high_sierra
    sha256 "10aab07578a5981586c49fa49cc28c7658be6c423dcd154c18c68bbbb5e1deb3" => :sierra
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
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end

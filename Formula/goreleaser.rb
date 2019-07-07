class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.112.0",
      :revision => "aaa39e98c922961186151719fb81ee9a3447b7ff"

  bottle do
    cellar :any_skip_relocation
    sha256 "82a698c014ddea1e81edd2f6a0c8bbe76f09d5b047ae38e7acdcf693ad25a645" => :mojave
    sha256 "b976091b7f5da262781405ed104dbca3134a024863b782b0786dba2427454291" => :high_sierra
    sha256 "dd76c48e07465871a8ea41179c9460c2debf3bf3e5d909278f7b757a07f737d2" => :sierra
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

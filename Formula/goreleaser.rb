class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.120.2",
      :revision => "449ed95bbe73fb88159e061352fcc786987d7d7d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1e47acd3363497d2a3a271be7a0ed715d0c2efbda70000f81ea918af0ae1e10" => :catalina
    sha256 "2b4542aa4f0b24bf7118c1bb36b8d222baf3261fcca1ed21c9b392a1c58b827e" => :mojave
    sha256 "4154cf60e3d6abb30cb38456c6301eac4505836ec708eff74f72aa517d186168" => :high_sierra
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

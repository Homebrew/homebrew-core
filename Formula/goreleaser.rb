class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.117.0",
      :revision => "dc29e85b509a106599cdd2f63796417bfda36569"

  bottle do
    cellar :any_skip_relocation
    sha256 "df71ff9bdcc1a6e396710d1d3645cb549ff9fd109661a0e37cd22c1691b89805" => :mojave
    sha256 "e1f61f12aefb8d563a35523582ff30eea1ad01b6a3e61e6c0b695c0d6676a41a" => :high_sierra
    sha256 "17b22a8e4392025fe083fa95af45ef8397a6f45386d910f804259bd98b02d48f" => :sierra
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

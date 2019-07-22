class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.113.0",
      :revision => "5c16574c8c87af2059346503c75d8623a44a40e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "635fc8bee40e94301a06932cb4086f5821d1545ae24d71103ca62f14bcb1306f" => :mojave
    sha256 "f007d35421c90bc7b1b0e4b0e1179fd2ab7f0a4e3a2192b9a4e0529973682aea" => :high_sierra
    sha256 "1556c819dcab240cfb4b0d97e42608333cf1af8b5ca49a7310e810ca4c9816d4" => :sierra
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

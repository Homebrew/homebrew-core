class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.110.0",
      :revision => "3f082c9252eb93a4bdf5045e06accbde37bb6dc3"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6113fcecd7bb129c406f6662d33a54e99b4d6f30cf77ae10fdf0e94a69cab27" => :mojave
    sha256 "dc41b30dc63916c59c62ca91b7ab2b889489929305624015ad47fdddd3afde97" => :high_sierra
    sha256 "cf9532e3c19697ef91bf206fe84b21aaee4fc0b0e31c94270fd000b0534156ac" => :sierra
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

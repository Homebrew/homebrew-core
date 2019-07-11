class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.112.2",
      :revision => "00cba176963d1344073c957f90504feaf992cf99"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fd2f5e7d95baf3d1276a7400222c975460251fbbf3f87db3653c5b0ff6928a4" => :mojave
    sha256 "2ff23c772a414505229862964495b44f7f95aa31374c40d147427e053d7804c5" => :high_sierra
    sha256 "fe8de5347997d82696b5b0da975c0d08171ee00c974e142bb4aa5007d4184b46" => :sierra
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

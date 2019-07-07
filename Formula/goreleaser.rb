class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.112.1",
      :revision => "a0de4bbb3cb30331cf25525f915a0e24cd9db92a"

  bottle do
    cellar :any_skip_relocation
    sha256 "aeb62bb5fb32e983c62d9e033bb7541e3f84dbb0f609a0a332aba3a9d1c06072" => :mojave
    sha256 "07915644795d0e0e86b1067ff8af3c988e051ddb7b5a168bee9edf0a2fc7b914" => :high_sierra
    sha256 "be57a6eae39a117d0579c8fe695be693c10056cb4d4aae2d2b518707e7321485" => :sierra
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

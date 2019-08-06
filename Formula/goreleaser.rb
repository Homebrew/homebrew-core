class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.114.0",
      :revision => "ab0e755a71afff0f13c5237f896ad86c8633a912"

  bottle do
    cellar :any_skip_relocation
    sha256 "7007b042ea7049053197ad3e15ece9d22b3d6cc1f7e3a825b4ad75f9bcdfde3b" => :mojave
    sha256 "e4ec906917b8f8d403ed63f2ff8fbcb78ba6d8ec84dc21747c775304e5195f79" => :high_sierra
    sha256 "7cf37ffdfd68445c34275c07a1159500dd781f71fd383a22b7b3f6feea39ac5f" => :sierra
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

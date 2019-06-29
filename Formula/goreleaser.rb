class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.111.0",
      :revision => "1cf34166b6128c5348ff75e6923d715251ab8c85"

  bottle do
    cellar :any_skip_relocation
    sha256 "2df4429dd8cc2872214a5c4611ef6179f211e73d34620df2336f84b1b521a646" => :mojave
    sha256 "6da1ffeeee651395cf20f18f03398acc9302b422ab8652aadadd9f34ab5a16b8" => :high_sierra
    sha256 "6c72a269dddde697775aa25cbc5af47bf0211a1d5a8ac0ca7ee4aaab41b9374d" => :sierra
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

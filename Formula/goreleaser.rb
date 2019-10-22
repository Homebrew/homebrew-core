class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.120.3",
      :revision => "e3d004814375cd5db1b9a0f2ba5580bb9b8f55f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff06b811c718e20f9c950d943669eb41e6cf4588f0f4a51fc5a9b71bdaa09862" => :catalina
    sha256 "8e2a4fb85ad75ff10d215da720f8cd42c857c3a791704e40dbfcb8e29749a935" => :mojave
    sha256 "218fc1145f94a3650a46ce24dfc1e0c0461b51eb7ab4ac64de1df44e2c2f7897" => :high_sierra
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

class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.121.0",
      :revision => "fdfe0487df5fc1114506fff5872e5c2a3d631124"

  bottle do
    cellar :any_skip_relocation
    sha256 "85d8fc409f3316be16ac231d4b0abcf86cc15e0a26157f9894eca087ff5b5337" => :catalina
    sha256 "7898295f727837318a3d196c7208a1a1d90e5b8e1b1434a7eeed1e98f315fdb2" => :mojave
    sha256 "e9bd12ae06d61703529e3db01814048f7f7c812c1be788686999dd7dbb750561" => :high_sierra
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

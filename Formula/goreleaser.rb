class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.117.2",
      :revision => "2c08ab87a13ce4a70cf89a691fbbc46c7da6c2e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "277eec4f91d832f7866e4f4301f3415213e23db3a7e0099e99f3984e947d6107" => :mojave
    sha256 "d9c87ed8a8e70af624181baf2a10555c32eab1500542ca38f0ce656a5ea41582" => :high_sierra
    sha256 "fd81544342d78c0f6033dd02b166ac66facece3bb6a99ee684fd3d0dbdaff78a" => :sierra
  end

  depends_on "go@1.12" => :build

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

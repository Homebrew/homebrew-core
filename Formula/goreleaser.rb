class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.123.3",
      :revision => "36126ec4869a93ef82895b225ee3d761fd87ae15"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f8c9febeb2e79e8c34f8febfde475ad140f1e607b2341d959cc6e215b570038" => :catalina
    sha256 "d982b4ae5a260eaf4b77da9290eee5ebaa5bcec63bc8a245d704c171aef22a2c" => :mojave
    sha256 "20776db5322df383d5928214ab36db499f613bd463d655a162141004a3593581" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             "-o", bin/"goreleaser"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end

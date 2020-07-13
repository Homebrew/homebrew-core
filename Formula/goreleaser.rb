class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.140.0",
      :revision => "8c93af20f8d8326c621aca2bfc61f9309aac78df"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6822c33f552ce79bfac47ddbc3cb09aa2e138f142a05891c4a70dcdc5a92c822" => :catalina
    sha256 "9f06b02ebe62611581e67bcd75c2ba92f1f2ac647e99d0f94a580f1a49d69436" => :mojave
    sha256 "d81d76cda82857154be4fb5aac3a413514f2cb30b0ace921e75dd0107bee036b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end

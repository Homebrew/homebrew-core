class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.129.0",
      :revision => "529cfca87d49cd93cdd7f8abd6eea6489c7cbd2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccb9628b8f8b13b72b40ca898536cc64c1af1ed5b2e146ea10746db15bbbe89b" => :catalina
    sha256 "d1d3bfdefb159196094863acc4bc700668e1b5137305ca0d1bdc013be4900c7e" => :mojave
    sha256 "c5efd2ef1a8d1e72946a329f1c774a564afd2ad619a913e44681874e7707033e" => :high_sierra
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

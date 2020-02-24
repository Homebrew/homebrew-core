class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.127.0",
      :revision => "33d39188fa74ff03bb134b092386c9525da6b53a"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa3ec0f9f58c40ee40a79627d72fdf519fc0c12f118229f3d21b8dfec37d480e" => :catalina
    sha256 "9cc949e57c01ee857f69faaafcf4e3faab0bb05d4312ad24d8613984b5ce7d8f" => :mojave
    sha256 "6d34dfe7d9cba80bb18a272d7f2b60ea796c641a9c498f05dfeae34a8a54aa6e" => :high_sierra
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

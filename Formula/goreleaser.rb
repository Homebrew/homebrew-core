class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.124.0",
      :revision => "5f5f263aa8cc293a5684786af73ef68a7b77b902"

  bottle do
    cellar :any_skip_relocation
    sha256 "0072feffc1534c6f12e071111d718ff476ff8abc56964ceb41c6508e1d6dcbab" => :catalina
    sha256 "755e7c21214ceaeb3ab9967d3ac278e1826e1b3fd30b28505c0da010573ca89b" => :mojave
    sha256 "3f8a792b472f481c6e5b02c2f22d0332dc6a6506f78f8aa2fe8cdf4d326695a5" => :high_sierra
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

class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.127.0",
      :revision => "33d39188fa74ff03bb134b092386c9525da6b53a"

  bottle do
    cellar :any_skip_relocation
    sha256 "8bc81d2a37fc2fac048cf933dcfb66ebfd2c7b9b472071ed30d4b00beabd2f2a" => :catalina
    sha256 "d54cc53bc292239c7d69d2e14bd64968f6c2a1e1069c158a941dcb98c4f182df" => :mojave
    sha256 "86b7555c1a0c57bef5c914a1c094f99320482629b626b69bacf75f75abe8c941" => :high_sierra
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

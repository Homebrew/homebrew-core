class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.79.2.tar.gz"
  sha256 "d8d2cfab66d51c3c1135c4c9c0939052b3c7ac0cb737b3a07870347578b6b6d4"

  bottle do
    cellar :any_skip_relocation
    sha256 "1713958f6e10c68f2205e8f870325d11c9f929f52f437567e9e2ee12f9128e40" => :high_sierra
    sha256 "75822d88ad46024331eafb37a35b60c6632f418792db40ad94e914a5958714d6" => :sierra
    sha256 "80dd54805021f3ef81b4ebc4003b9e932b63bff12afba9c3b759485ccf985766" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/goreleaser/goreleaser").install buildpath.children
    cd "src/github.com/goreleaser/goreleaser" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o",
             bin/"goreleaser"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end

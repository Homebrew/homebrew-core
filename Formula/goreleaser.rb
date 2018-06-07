class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.77.1.tar.gz"
  sha256 "ee4788a44c1f5700188d1933d42f9637b682cce54333d3c5d267564d614f44c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9924da73adf0087e84f4672a4a1df8f75a5da11982306d483ec4f47889c10ab" => :high_sierra
    sha256 "e37fed701bb1bf84ef53562c6817b26497089de07297023c484e5d8c04566266" => :sierra
    sha256 "b5a8e06bff190741888646a6564da88add857f8242229e5ff7cc9d1c500228db" => :el_capitan
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

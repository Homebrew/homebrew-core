class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.76.1.tar.gz"
  sha256 "43ccb3ced370d63516100d9823aaf133b47730a9915d8a35e0e99b0d57eba9bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "186e6018ab77a76af9173d862689ca623051a09f4dbbc240562429cab3465958" => :high_sierra
    sha256 "9952dac68c88751164937c5fbe99ed1f8e8a0eee864980a909f217c8a25bcef7" => :sierra
    sha256 "90fadf1c7dbd40353acd03a625a68d3157b71c11b0f5ee933b62c290be8c42c7" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/goreleaser/goreleaser").install buildpath.children
    cd "src/github.com/goreleaser/goreleaser" do
      system "dep", "ensure"
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

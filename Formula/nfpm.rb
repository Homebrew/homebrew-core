class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v1.7.0.tar.gz"
  sha256 "417289dc116bab303067d34ef9285174fabed1eb66cd437c013d9556e81ae372"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9eca2f8f1e72d5d22290a512f70bf3f2a8d2fce04763df9f546990a5cab6c578" => :catalina
    sha256 "cc2a9cab6f92a4f49b15ce365e2980a66ceadcc634222b66f35673fc8e3dc8e6" => :mojave
    sha256 "ccbbf75e6160fbf9a0dbf1e7b425f20be7a879dc89c68ef9cdf2ad2e0cc14817" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.version=v#{version}", *std_go_args, "./cmd/nfpm"
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example config file", File.read(testpath/"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath/"nfpm.yaml")
    (testpath/"nfpm.yaml").write <<~EOS
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    EOS

    system bin/"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_predicate testpath/"foo_1.0.0_amd64.deb", :exist?
  end
end

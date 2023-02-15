class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.26.0.tar.gz"
  sha256 "63774508d2610a61ddcfc0a15c7f67c690dad1c50725ea16b6470486ea604c80"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec938f513669aca24c25dffa0255d7bf7ce98b7e2789e3d97afd5dd7195fd626"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a5b4f068f39c0311531fb1881f4da4345bfa1469a3df272d382f2b128771ea6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d149becce6213385628c4bfacacee85dbb7bfe66883d2d9ed19bf4bef047d7f"
    sha256 cellar: :any_skip_relocation, ventura:        "d805e36b6ae88deb1cba30d2f38510ff1291bde49ce337dddd762cec3b66c9ea"
    sha256 cellar: :any_skip_relocation, monterey:       "b094f207d3065391da153b37b66ed29f01e53ca51988bd54d0abd58c05c51ef6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7873f9394d398f9486bce5340c42eef1e2bece1c2389178b6cefa0883e02c3a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c70bcd2fa7782f3e9de5d2b287da72e8eed105c4b495d2f565339a09611c1122"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"

    generate_completions_from_executable(bin/"nfpm", "completion")
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example configuration file", File.read(testpath/"nfpm.yaml")

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

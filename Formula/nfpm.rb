class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.16.0.tar.gz"
  sha256 "082cd8c2df00a73e249350a117d87ee614427b02b64f1c06fe88366abde420b1"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b012268494a6f7387dbff78d9f6e8ab87a52fef9c65562b5bd4a3c849395b484"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b52d0c89ec15d4ac452acf761f7e641d03ccdce4583e7d90f778468dea43c0e3"
    sha256 cellar: :any_skip_relocation, monterey:       "4b2339cf212dea21217504fd2a853ec8ce81226ee0b26d638af0efacd6da7fc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "65219b66837c5f08bdf595655b34e007b0d6a5e096e38d7be8eb764712f9d686"
    sha256 cellar: :any_skip_relocation, catalina:       "15721b7a135cf07e7c10c91d749b7ec50a614a6d683524eaa53f3687187a43e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "181534441a5df7bf21828866524233ce1d2ea7996aa15bf4f5e028b9b7f081cf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"
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

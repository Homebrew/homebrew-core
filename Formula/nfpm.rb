class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.11.2.tar.gz"
  sha256 "a76e4cb2900a29ef75c90f3cbeb62ae2ae78d93a9dc60d7f113e5d6f2c67794b"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ddfc932308e6c53e4908c31a5be6a0c136b1f13995dd76fa058c20db3c9de16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a03e999ae1c00c8c81a26425d48f15456cafdfe7c67a41b17604d5a4e3a9af7"
    sha256 cellar: :any_skip_relocation, monterey:       "44873a04cd2b4aeb3f57f5e1ce7aaa0f52ffaa5463fb44508091c6f671c8ab61"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d236b1f250a72e5245760089279dc7b6d41ab9ddced706ef1045a093d532bd1"
    sha256 cellar: :any_skip_relocation, catalina:       "8bc7fd31e2259177fd1f5892d14abf311c29e9004e2a3d34b725f6881aa6251b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36f259accf9a31f5f8b364429c3bb4a1cee78a85038a8f313ab454f88ada944d"
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

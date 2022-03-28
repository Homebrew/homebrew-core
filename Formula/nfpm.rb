class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.15.1.tar.gz"
  sha256 "ce43c832311f3e8ce0432d6e7a72e91789705de309cfb42883e496d57f56bcec"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9af0e99839e72180152a0ab6f3a7f1b79f33e5ab8d18e4f06df79305353f1929"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12fae285d5a27beb925cdabd8f735acc2502701d25829850146a72e3b0ffc901"
    sha256 cellar: :any_skip_relocation, monterey:       "ec6b4804b23d326c03b62b598dada23b3bf36b10defb774ab981babe1a45058c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fcac57ab3c802b0b36827749e9afc207cab41be9ad5af26e5139de3e51809f0"
    sha256 cellar: :any_skip_relocation, catalina:       "e2fe66a0eb9e1af0ce4352bd6a4dbc5090dd5d8e30a3239431536f56fc9e577e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc7a4e1f13c6ca23e393c53b78c2aadd98986b669a75e28d1c696207aecf67a2"
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

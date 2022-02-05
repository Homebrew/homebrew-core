class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.12.1.tar.gz"
  sha256 "fcfee92799f390fd8b2c8a3eb481ff54ceed53057afa707fbc3fa4188b95b555"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afb517559d8f6a7ddcf42475362bb7ad351d3655a63811f452abcae839c07184"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d2dd8acf2535adaf08b579b997c42cb32573921a93d21dd1cbc5bee836e10b9"
    sha256 cellar: :any_skip_relocation, monterey:       "4183acdeef00b141d079c688564a2585abdcd5b5a9c2cdd6594086ae72bd8727"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1aa20f14067b4237faa2bc1a8c650a603d2bef38fe491df29e3c3282a0e4564"
    sha256 cellar: :any_skip_relocation, catalina:       "0ea000b1d35737aeb97292414f7986bc26efae1c2a0ae0358b5dfc9b3f14c255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7862731264baae7b01efe8861ae68008aebeb24c227b099865cf937aa6934e64"
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

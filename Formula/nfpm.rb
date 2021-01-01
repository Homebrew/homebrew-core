class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.2.1.tar.gz"
  sha256 "fc8d512604368fa9bb134862876e05ce2b9892e151a03636a5d214b5f8597754"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c373825bef200f192b530e09a7b2a223dc85210ab484ea7d9b4820cfb608010" => :big_sur
    sha256 "ad7653296c049db4b5b8b1f0f54889b5102473fe3b7c268936efb5efbb1d1968" => :arm64_big_sur
    sha256 "1aa61ac2f24e9c15ba0be37a059e9870361f7056b358944712fdd1629f021533" => :catalina
    sha256 "8bfef1c749b6b3504f0b85027976ed909ef5766afbf8db46f356a1fea9ad2ba5" => :mojave
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

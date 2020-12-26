class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.1.0.tar.gz"
  sha256 "68109a33f4355f18a08736e26a31d35b1bc696065690a93ec38baf0c640c72b4"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33c2cd66016099e858b4cf42fe946bb0b808eedc433165559e7ef9c57d888461" => :big_sur
    sha256 "d7192c4bb221d4affa42ffd2080b1b3e340e6e64a56c70c32deb90fb153a42cc" => :arm64_big_sur
    sha256 "4c764458e6feff5d2996c83edf48bd00e06717d15647e7c292bcb296c6657788" => :catalina
    sha256 "8c35497ea966381abed6e9651ccfd8687feb73e629050cd6b1d1388910ea9ddb" => :mojave
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

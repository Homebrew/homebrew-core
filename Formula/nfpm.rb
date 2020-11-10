class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v1.10.1.tar.gz"
  sha256 "253de7be378ba2177ff8cfca028b1a3a6095572df243292195280ad031ba9e3f"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "81394b9f3a3a832205703ed4096ea9cefe6a3ec4d39b6791f31953a9059ee56a" => :catalina
    sha256 "f978a4beb2b0bf127887ce2614ea16866427e64cdc2cfe613f3d609aa9e9d588" => :mojave
    sha256 "db2a9bc15314233b8fe6140c660ce780d89ea3f0dbeecb169e7c46a32e101bd9" => :high_sierra
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

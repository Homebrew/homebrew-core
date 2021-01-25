class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.2.3.tar.gz"
  sha256 "8e5143d732d49dbd02ef8f778de5bbb6ca16cb9f91843f9c401596f73c1c4294"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "402e53dc2b7b5862650700d448d892a2871520824f1cff960c49a71024e2c2c9" => :big_sur
    sha256 "b5865bf3035ba42cf8006693de37fa8186ce9a1b9bff4e747023f6e046e84b44" => :arm64_big_sur
    sha256 "1adb3b0950732117f0fde089b6be96688d90f2d5bc69322fa77c45559a481b8a" => :catalina
    sha256 "f443bac7b2f5fac7623ef365a9629c35321d83f48c374212356e847d410d3feb" => :mojave
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

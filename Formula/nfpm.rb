class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v1.9.0.tar.gz"
  sha256 "084a081c02caff3d789debfa088f61e090a30dbe4cb4bd4831f1bde9375420b3"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "20810fc389b6168ef91dd02ac47c51074c51293a522cac70d6d127e924fd7ef1" => :catalina
    sha256 "e5b68cbfdb32df0a981218e9d22066cf861dd408a5831b2a96b8479f89fe94fb" => :mojave
    sha256 "227ba1bf229111601ad634b47ffeaafaa02d8d8aba8b56e7ed234df6583442bd" => :high_sierra
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

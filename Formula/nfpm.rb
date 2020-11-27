class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v1.10.2.tar.gz"
  sha256 "c08122e1579c3614350108f02a577078631fc354eade7a0eb6458895f98c93e7"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7002218cc431f34e9b4268d64f47600ff099432b069f1b56db73cacbaf51ddf1" => :big_sur
    sha256 "38209c4b5ed7cbc4953c562ca59d5d91b72cf600efc5374b1a4042f521e2023f" => :catalina
    sha256 "d1a4dc256f216e6f88f5cf910329005891717e5d017a8d4cd9acb53ccec6a0c3" => :mojave
    sha256 "bb076ea6caf5d5907f4b01e61f8db16bced292573f79b7cc6fdae2e6305d64b2" => :high_sierra
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

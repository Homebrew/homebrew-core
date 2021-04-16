class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.4.0.tar.gz"
  sha256 "b6650d9ab189bec4b8bacad9ec0e652a467f59ab70cb4eb126f76bc5e21df5c0"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3350ea19d4dded62f2783ce005f0f3d85d7306b20d74226a35a96d1ebcb8531e"
    sha256 cellar: :any_skip_relocation, big_sur:       "faa9b675133c65f36466ab74574c03f6148df54dd32807a7088e7238bc884b9b"
    sha256 cellar: :any_skip_relocation, catalina:      "6818db44d0eefc93fce49627753178c1d6b67ca2c6a2c98563bc1f5d09760709"
    sha256 cellar: :any_skip_relocation, mojave:        "cabf7a14c22bfac597202ffec6da1aac24ff98eb43859ad3cd77fa1f7444028e"
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

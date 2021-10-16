class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.7.1.tar.gz"
  sha256 "827cafe1647d68e5db7c959922f83503df7f3b2e06221e184bfa0f53455eace6"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e7665497b67424a37826d2142e3bd7980b0e11bcb706e70aa344344b773c9717"
    sha256 cellar: :any_skip_relocation, big_sur:       "7fa39abf95594d9bdbd82a0c716dd699865168be3a402becb4488809ad7e54ff"
    sha256 cellar: :any_skip_relocation, catalina:      "e1f75f2a72468ecd2c355199fb6c341a6835c9f297e8202ddb84a566276b8281"
    sha256 cellar: :any_skip_relocation, mojave:        "9f1bf204adc1d04d1e1274a50de536cfa4964cf5fef828524b7274555f7b4d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52651225175a48aa5ee3536bcd5b7aac3d908df9f60a71f22efcdfebf9fc5b3f"
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

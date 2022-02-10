class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.12.2.tar.gz"
  sha256 "6f961807932fca173ed759dddf468e62188878465448450c73a5f4b3ddb89d6a"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae5fa2db117451cff42cdfcefac9faf01262d7a26366e7ed56973da1465deb3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cffa5319fe63d07a348d8dc792d2684e79bf416754f5620ce37aad1aa511272"
    sha256 cellar: :any_skip_relocation, monterey:       "5b9c193a0a26debb54d177769354fa346362695df9ae13e3f365892fbd75b15b"
    sha256 cellar: :any_skip_relocation, big_sur:        "37428bdd97672287895eeb2a4e6164dafc89919ecd28e2673107c340370f184b"
    sha256 cellar: :any_skip_relocation, catalina:       "386cbf8e420a4f4498e9bc6edd59f984395d024038f74155f986a8a4567d4cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7d5fdc83ba2d326b0ebcf74586e2930b0b88f547b9d582744b2254e12952456"
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

class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.27.1.tar.gz"
  sha256 "cee72ec1e22eebc5d1fdbfe2aca03cbaabdb452f71a26a52d97273ad5fc6a437"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a18674cea52759a847d17adf912cefb9342fb5dcbfa40bbabedf42ac116e547f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a18674cea52759a847d17adf912cefb9342fb5dcbfa40bbabedf42ac116e547f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a18674cea52759a847d17adf912cefb9342fb5dcbfa40bbabedf42ac116e547f"
    sha256 cellar: :any_skip_relocation, ventura:        "acb2fe3f8bf6607e975fd85ce8b7adb367bef92f8cfb11c7cd1161fd3680a129"
    sha256 cellar: :any_skip_relocation, monterey:       "acb2fe3f8bf6607e975fd85ce8b7adb367bef92f8cfb11c7cd1161fd3680a129"
    sha256 cellar: :any_skip_relocation, big_sur:        "acb2fe3f8bf6607e975fd85ce8b7adb367bef92f8cfb11c7cd1161fd3680a129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96b678bad44b5953ba270fa6a93b454fa0e51c15b0b63e18946b70c31b0f2669"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"

    generate_completions_from_executable(bin/"nfpm", "completion")
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example configuration file", File.read(testpath/"nfpm.yaml")

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

class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.9.1.tar.gz"
  sha256 "467e00f8fb74adb5b8b69c1d6208f51f853d618c44e143931c9581d85414266b"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98bf5e7a614c7fa5092423de55d43e4a7685d19777fd940efad66d0c3f795ffa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfc1d23a5555298e0a6260df107c8af20aaa336e78a0bbf729e92e896162eb30"
    sha256 cellar: :any_skip_relocation, monterey:       "9d12040670dcd1d9cdf61f83b6feccae33640934cf226004808668926e8137ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d50a6361f4d8a05af497841256e76d9401c809df32c50cd03bca764ae6d349a"
    sha256 cellar: :any_skip_relocation, catalina:       "7ef2e22c9347bf3085fb3eed434d30ce27285fc489efdd37d23baed511b44089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c090acef690a647e970c1c5b4c9af7e1347ff8dc7a395cc54650e4828ceddd3"
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

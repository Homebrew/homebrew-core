class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.31.0.tar.gz"
  sha256 "c568ed90d9fdd583b4ebcc3e029d98e004203802222dead6b14b24444fde18a6"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8674ec6536934b8a89e30de50e458560220f9f23660ecc62eec5eb0c7fa752b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8674ec6536934b8a89e30de50e458560220f9f23660ecc62eec5eb0c7fa752b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8674ec6536934b8a89e30de50e458560220f9f23660ecc62eec5eb0c7fa752b2"
    sha256 cellar: :any_skip_relocation, ventura:        "26a74a283215ddc806d790b120f61961ddd1d53954f67994112f8209289a8c49"
    sha256 cellar: :any_skip_relocation, monterey:       "26a74a283215ddc806d790b120f61961ddd1d53954f67994112f8209289a8c49"
    sha256 cellar: :any_skip_relocation, big_sur:        "26a74a283215ddc806d790b120f61961ddd1d53954f67994112f8209289a8c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "293b79858e41d1a81681e314f86dda1d9835a46b6cd372c372b8c80cb956c409"
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

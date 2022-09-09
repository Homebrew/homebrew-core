class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.22.1.tar.gz"
  sha256 "8bd267c9a64d9e0a208a20ddc5a918630a4347b8bcdcf4a8d35f7b77b303393f"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3e345c654dd3b03a6a90e9efb727991b88b44484790ece591690ec5f03d0493"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6ee32696bb0b3c931683c9e735b35e2283ae36a4caa2f019777676644548dd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ffcdb5c01a67f268b6b70beb2c0b05dadc03251276834cee48d3022ea3a266d"
    sha256 cellar: :any_skip_relocation, monterey:       "acd28f929242690fc25e57b0941390a67892b6a5fb47320ad075dec02e1ed105"
    sha256 cellar: :any_skip_relocation, big_sur:        "baccf487553dfba911d62fc87413d52ad2a10db76c57ae0ae7ed224e1990a939"
    sha256 cellar: :any_skip_relocation, catalina:       "eca52ad18ddb108b2fc6eef23030d4fc15aa245eed4a132b1d130ad1455b7870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aecf90bfa79526bca3eb3bbf2551ed6eb56ecbb17bf6f90c2de7224b3d94fb50"
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

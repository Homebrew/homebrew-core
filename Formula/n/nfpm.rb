class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.43.0.tar.gz"
  sha256 "5575a14fc6bd4ce555d3bdfc5453e65bcd62e592a5163aa65ef9f1434bdbb283"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "330ede9afc1032c0f42e600c33d6c1a7f3a2f1558600ee8e560b8513c03d912a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "330ede9afc1032c0f42e600c33d6c1a7f3a2f1558600ee8e560b8513c03d912a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "330ede9afc1032c0f42e600c33d6c1a7f3a2f1558600ee8e560b8513c03d912a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b38534997ec8301872086c84b74445b1a5cec0960cd195b2d444b6b2b729443c"
    sha256 cellar: :any_skip_relocation, ventura:       "b38534997ec8301872086c84b74445b1a5cec0960cd195b2d444b6b2b729443c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc22f1ba1f8307683c5075681b37ad011dd41ddfff2d04aee9e72d8ab8eb6c33"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/nfpm"

    generate_completions_from_executable(bin/"nfpm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "This is an example nfpm configuration file", File.read(testpath/"nfpm.yaml")

    # remove the generated default one
    # and use stubbed one for another test
    File.delete(testpath/"nfpm.yaml")
    (testpath/"nfpm.yaml").write <<~YAML
      name: "foo"
      arch: "amd64"
      platform: "linux"
      version: "v1.0.0"
      section: "default"
      priority: "extra"
    YAML

    system bin/"nfpm", "pkg", "--packager", "deb", "--target", "."
    assert_path_exists testpath/"foo_1.0.0_amd64.deb"
  end
end

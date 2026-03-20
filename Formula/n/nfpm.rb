class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.45.2.tar.gz"
  sha256 "dc56c9182c842fc9d1b5e42f1c0f4fd8815b7ec7ae49a281de767a5b5c5e099a"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27f7692a1675c7f74a52d62071a0f962cb9f0e764067432de1e1fda829c7b75f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27f7692a1675c7f74a52d62071a0f962cb9f0e764067432de1e1fda829c7b75f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27f7692a1675c7f74a52d62071a0f962cb9f0e764067432de1e1fda829c7b75f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1eef266b26c347d4c8af767ea85936bbd4a2f30467469153b25b5859458e8837"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e222db5c2e116944a31b0823a6e76c75657b31d78e46b17721e06ed368f563ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e584ed4f98c256694f3d39af2e4571429e0aa7b7bd3fcd1368eeffbd8a1f996e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/nfpm"

    generate_completions_from_executable(bin/"nfpm", shell_parameter_format: :cobra)
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

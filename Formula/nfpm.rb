class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.3.1.tar.gz"
  sha256 "56193d06cb830c347c23ba912fb71711d5292a673b3e77ddc5b23e51103e61ce"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "47ca3487f0f24eb9a20856dddc398f6cd991180105b0826ff37af94cb3ce91f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "7fe18a4f795a7fe333d0ed429cbab8c5306e21a00d657a59eccb144ddd145c4f"
    sha256 cellar: :any_skip_relocation, catalina:      "48c23c31dda9c38f94c4172b3157d1dd78c2e6c3e30dc964891fba8a499b8cb4"
    sha256 cellar: :any_skip_relocation, mojave:        "5a23059ed093e40ecbeb5eebef061b0f52fa9b84d48a04c4b8e94a22dc247373"
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

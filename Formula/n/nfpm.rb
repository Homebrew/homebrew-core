class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.48.0.tar.gz"
  sha256 "878dab9c3e02549f981a227957fd73c042ab5316bd12d201a0db94445284df1b"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2da6adba5332a0c099c314d716019779c1c748380ee5c0f029c70352d0120451"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2da6adba5332a0c099c314d716019779c1c748380ee5c0f029c70352d0120451"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2da6adba5332a0c099c314d716019779c1c748380ee5c0f029c70352d0120451"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "16de4d434f2791c82fd24304d89774d18e9cdcb494fc21ebd6fde3109b0b53b7"
    sha256 cellar: :any,                 x86_64_linux:      "3d00d105d54bac9cabf3ad3795b19819b177c35641ae1e1221e2f51a400a33b8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"

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

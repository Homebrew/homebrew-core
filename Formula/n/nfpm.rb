class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.49.0.tar.gz"
  sha256 "cb94db4244d324c8b1daab9d9d27d553e4b7ad9ec6e152cc58a2e80195bc410f"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69a48deb86446598392ad0dbb4e3deb15e9f3d930f47397e785cd9795cffc844"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "69a48deb86446598392ad0dbb4e3deb15e9f3d930f47397e785cd9795cffc844"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69a48deb86446598392ad0dbb4e3deb15e9f3d930f47397e785cd9795cffc844"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6e00ce7ddb5195d20ceb89ca8cd3ab63e547f4d770898e9e62946b1719f4ac32"
    sha256 cellar: :any,                 x86_64_linux:      "0fc77878b04d5d51107928a1233635fb461c7da86554d7eeb63c40fe420151fa"
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

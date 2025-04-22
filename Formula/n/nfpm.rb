class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.42.0.tar.gz"
  sha256 "038541bc4d22fe52f79e2925d6b64d25398970ac9ddc32a4ff1823f189cd8ea4"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39d4448467d5d192affcbedf2c70f701567ef024cdcbcd94b3335a4921e3d4f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39d4448467d5d192affcbedf2c70f701567ef024cdcbcd94b3335a4921e3d4f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39d4448467d5d192affcbedf2c70f701567ef024cdcbcd94b3335a4921e3d4f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d11a3bbff39d65b432875c056285d9c7bf3c4458793a653ed33125524503101"
    sha256 cellar: :any_skip_relocation, ventura:       "1d11a3bbff39d65b432875c056285d9c7bf3c4458793a653ed33125524503101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01075afc56f6fbbe34b4e5de4a5bb4b3d7617fb77abedcfcdaede017aba6bb45"
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

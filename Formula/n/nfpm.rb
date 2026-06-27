class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.47.0.tar.gz"
  sha256 "906b8dde0c5626376779f3ebddea3554b0eb6e1b8450a09bdc746cba92ef5dea"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60c13a961c2dbd2dee9691efe6cad1016731ef9d7706692361975a7ee1441739"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60c13a961c2dbd2dee9691efe6cad1016731ef9d7706692361975a7ee1441739"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60c13a961c2dbd2dee9691efe6cad1016731ef9d7706692361975a7ee1441739"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b152ceac3d45544db522af2e1298c6b63aded4d9f7eca5d04cd776975c025ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ab518bcdb693665f49f66c7e31c5a18bb12c727a30ad482abca26e06364dd35"
    sha256 cellar: :any,                 x86_64_linux:  "9d2752ad789936e4b51eeb49095b952ce234fe15efbbe6497bf9f9e949ac654f"
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

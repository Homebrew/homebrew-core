class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.46.0.tar.gz"
  sha256 "b4d6f2065e3a6c2a59520086b149dd51872dc6362bbd8f9df9bd655ca82111f7"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f598b7cd273a7f5e7d33890bf900e6659f4c1b1db43d892dc868c564cffc0e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f598b7cd273a7f5e7d33890bf900e6659f4c1b1db43d892dc868c564cffc0e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f598b7cd273a7f5e7d33890bf900e6659f4c1b1db43d892dc868c564cffc0e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b236bc7f7629a252e7e4e6a104adc7dfdcf4456f38dd06c5bbe357055798378"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "944fa1fcc214adab222ebfafd0e783210616c526425b30821334987b5ab9724a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c1899c36e57463aad13780249c73531f5dabb2cb4dcd222352bc68d3817383c"
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

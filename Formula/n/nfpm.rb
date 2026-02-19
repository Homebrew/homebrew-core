class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.45.0.tar.gz"
  sha256 "6a8e556d02b1b485e11f4bb7d07ac61c55a881b4facdd9b63bc0f04346b91e0a"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e73cbf704f5e41fdb63f92588c579634fc97c0d4ecdd7b9ab86084b51cf699b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e73cbf704f5e41fdb63f92588c579634fc97c0d4ecdd7b9ab86084b51cf699b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e73cbf704f5e41fdb63f92588c579634fc97c0d4ecdd7b9ab86084b51cf699b"
    sha256 cellar: :any_skip_relocation, sonoma:        "40516c17b68625da2f6abcd3a1c985125ac4a34553304d5bee204d486683ddbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5caa59328978c2e9586ded068af47d6241620f2fc602616641786fc1a07078a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6d97b3cd19b75bbfa54c96a4515cea2b3417b81003e096a6f257bef5d012031"
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

class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.43.3.tar.gz"
  sha256 "4e270a9a1d05d18c4966e422f4f6d4d8049a729cc5a2fae9a6db4b8bf0a7ba15"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60eb6e2afd7d903a4a4974234c2ce1651df024e88fae0bd86fed7d9a4cc153f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60eb6e2afd7d903a4a4974234c2ce1651df024e88fae0bd86fed7d9a4cc153f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60eb6e2afd7d903a4a4974234c2ce1651df024e88fae0bd86fed7d9a4cc153f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "818c2fee78da738df9750c7ab5cd1dc62261128f2cc5944e5f8621491cd209a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "757a4abfa35bf0904f686e19b47e5d6f3a99cb8e8296bf2d859c28908ad74381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6abe07ab30fcefdf9acdc1a29bc813d1de1d1bf3f31a4e263b720ce814d5ddc9"
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

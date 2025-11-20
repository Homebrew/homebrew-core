class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.43.4.tar.gz"
  sha256 "7df017567b12364cfadefa78d59909ae0a3672f760c4c0a8ab5b15df40dfbd27"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9b367b659ea41f27e5fcc41878fad3cfe7e73a6a4043569e8bb53fa7450a560"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9b367b659ea41f27e5fcc41878fad3cfe7e73a6a4043569e8bb53fa7450a560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9b367b659ea41f27e5fcc41878fad3cfe7e73a6a4043569e8bb53fa7450a560"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7141c98a56a8ce6bf246b57336229e8931bdcd3a27a1940f6b98e5659a0f9f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1526ec819aaf209da00da1d0099410308f3b786dfc10309898eed249e1838e56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a67d52167dd13f4a151ef400dc47198c11cede36d49680bae1757695baad600"
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

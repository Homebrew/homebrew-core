class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.41.1.tar.gz"
  sha256 "6fb9713f5b3ec4e44c256b2b22505eb13b8e53a1fa95dc6044a7b7ec2ee9e754"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ee255e4c65ed26ce783b072b25a660ccdaf7358205af743f8749eb0f97a5800"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ee255e4c65ed26ce783b072b25a660ccdaf7358205af743f8749eb0f97a5800"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ee255e4c65ed26ce783b072b25a660ccdaf7358205af743f8749eb0f97a5800"
    sha256 cellar: :any_skip_relocation, sonoma:        "43d9165edff93ade8e91fe577de70477a0d8bf8868aa17453f0d5d6705912e4e"
    sha256 cellar: :any_skip_relocation, ventura:       "43d9165edff93ade8e91fe577de70477a0d8bf8868aa17453f0d5d6705912e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07ee58dc663f1e3d9972a5f4c0964d8d1c51eacb389cc14ab96d7c378c6b063a"
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
    assert_predicate testpath/"foo_1.0.0_amd64.deb", :exist?
  end
end

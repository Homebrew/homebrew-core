class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.30.1.tar.gz"
  sha256 "0a1c9f5439e4fc155dc8e073d05ec7815e0dbeacffdbfeec107cd60ac6e6aa6e"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f05352b50c527332c80de3cebd6226dc310691ad1421b8bf60c65f794e4f9f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f05352b50c527332c80de3cebd6226dc310691ad1421b8bf60c65f794e4f9f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f05352b50c527332c80de3cebd6226dc310691ad1421b8bf60c65f794e4f9f2"
    sha256 cellar: :any_skip_relocation, ventura:        "33b64cd89fd25b26eb8a2b2ed88fa22abbb2dce308f2ec9ec9ade602f623d696"
    sha256 cellar: :any_skip_relocation, monterey:       "33b64cd89fd25b26eb8a2b2ed88fa22abbb2dce308f2ec9ec9ade602f623d696"
    sha256 cellar: :any_skip_relocation, big_sur:        "33b64cd89fd25b26eb8a2b2ed88fa22abbb2dce308f2ec9ec9ade602f623d696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b815ae8d29b0e72def565903f2e526d03e5921dc7a3c7925b4f2d21b66025d83"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/nfpm"

    generate_completions_from_executable(bin/"nfpm", "completion")
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/nfpm --version 2>&1")

    system bin/"nfpm", "init"
    assert_match "nfpm example configuration file", File.read(testpath/"nfpm.yaml")

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

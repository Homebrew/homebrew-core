class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.40.0.tar.gz"
  sha256 "c177f596c7bc75e10537422bacc376f77e840f986af092fa0fbc3b93611f862c"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7254db30626be63a67ad947e13bea8b34890531236e810b80d5e218f5206523a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7254db30626be63a67ad947e13bea8b34890531236e810b80d5e218f5206523a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7254db30626be63a67ad947e13bea8b34890531236e810b80d5e218f5206523a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7254db30626be63a67ad947e13bea8b34890531236e810b80d5e218f5206523a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a4bc37b8863bfccda231bdf7e90cc97a66dbd395552b37c6ee45497f0c02fc6"
    sha256 cellar: :any_skip_relocation, ventura:        "2a4bc37b8863bfccda231bdf7e90cc97a66dbd395552b37c6ee45497f0c02fc6"
    sha256 cellar: :any_skip_relocation, monterey:       "2a4bc37b8863bfccda231bdf7e90cc97a66dbd395552b37c6ee45497f0c02fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "def4645ec4d80935f3046168f38b59975c5d1e9a91e2d3b7804906c5f8211bb4"
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

class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.28.0.tar.gz"
  sha256 "0f526b9bf05b8484638f76682c5c6afe26dd98848773cf620db2fb9c7334bf43"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34764cf21040f1668910dcbe646597b23bfc493a967b68d1586c3f15ff42e500"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34764cf21040f1668910dcbe646597b23bfc493a967b68d1586c3f15ff42e500"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34764cf21040f1668910dcbe646597b23bfc493a967b68d1586c3f15ff42e500"
    sha256 cellar: :any_skip_relocation, ventura:        "32107509a6f5fa256221288eaedb0828a978acda7466ffaa82485a1d57e9841d"
    sha256 cellar: :any_skip_relocation, monterey:       "32107509a6f5fa256221288eaedb0828a978acda7466ffaa82485a1d57e9841d"
    sha256 cellar: :any_skip_relocation, big_sur:        "32107509a6f5fa256221288eaedb0828a978acda7466ffaa82485a1d57e9841d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f42d6ea3d8db2a4031644ea2f981748fbb8f1cc2b8ba161203de62cb5e915385"
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

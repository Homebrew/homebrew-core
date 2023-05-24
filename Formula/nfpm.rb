class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.29.0.tar.gz"
  sha256 "c49a86c00bd87b8d04f2f07aa8175b544c78e9ec085b714471dc4ee2d50cf110"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22882f32dee2666733688a9dbd32ca43202fa463a5a54f7209b958efc07d2346"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22882f32dee2666733688a9dbd32ca43202fa463a5a54f7209b958efc07d2346"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22882f32dee2666733688a9dbd32ca43202fa463a5a54f7209b958efc07d2346"
    sha256 cellar: :any_skip_relocation, ventura:        "4bed36ec52fcaad720e755bf694ad0b13970387e6e51e25fca8d5aac1bbd549a"
    sha256 cellar: :any_skip_relocation, monterey:       "4bed36ec52fcaad720e755bf694ad0b13970387e6e51e25fca8d5aac1bbd549a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bed36ec52fcaad720e755bf694ad0b13970387e6e51e25fca8d5aac1bbd549a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00a33f0e27e48bd5fc5f22915c60e40c6ab2f2d9eeb587a3df7e761d914790a0"
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

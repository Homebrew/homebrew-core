class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.43.1.tar.gz"
  sha256 "12cc8d0d28eb338030ec4b1eff0afd87c35f6a43e9425a2480ba10690d8f02be"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "579d609f05b4de97fcfcb7d91fa17bc82e99bd80460c26d834c5ff5051645374"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22ffce0a8946f990dda86836aa830db88eb0f5b60735573cc6fbc627a6fcbf0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22ffce0a8946f990dda86836aa830db88eb0f5b60735573cc6fbc627a6fcbf0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22ffce0a8946f990dda86836aa830db88eb0f5b60735573cc6fbc627a6fcbf0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a860ffe8973b003ba97af58a57ae6b4e35bccdc81561c9b5ef1ac8a1c16fe89"
    sha256 cellar: :any_skip_relocation, ventura:       "4a860ffe8973b003ba97af58a57ae6b4e35bccdc81561c9b5ef1ac8a1c16fe89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9864efe69056f9cf5d64fc8cbc1df74de654d472bd4bf257da4add051af3553"
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

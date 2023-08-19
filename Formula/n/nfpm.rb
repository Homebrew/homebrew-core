class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.32.0.tar.gz"
  sha256 "3f475bcf4021b65ff82e251b93b82004036b39a7b293684b11b04105340aa6db"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c697e4843c97c653a913a869be1951f32759d914feb8eb92cc10dfcdd6a50cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c697e4843c97c653a913a869be1951f32759d914feb8eb92cc10dfcdd6a50cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c697e4843c97c653a913a869be1951f32759d914feb8eb92cc10dfcdd6a50cd"
    sha256 cellar: :any_skip_relocation, ventura:        "61b09b8faf29fe25520f8f6f46a9b0e484c9be1312c6039b3436dc6a102b47d6"
    sha256 cellar: :any_skip_relocation, monterey:       "61b09b8faf29fe25520f8f6f46a9b0e484c9be1312c6039b3436dc6a102b47d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "61b09b8faf29fe25520f8f6f46a9b0e484c9be1312c6039b3436dc6a102b47d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87e60d0d6675112ae58f08958739cf56942e411d61b7a919cd8572c733cdc136"
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

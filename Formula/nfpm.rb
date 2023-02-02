class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/v2.25.0.tar.gz"
  sha256 "76f260f7c04a28bf64d487ee017dafd9d6bd5aba2b4a61782276b384aa782e3a"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "959649f669b8c40580a26f068107bdae72bd6d2de8d33670316f0204ba3812a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf9dd504bb95be64fe175d74d1165259e39f66ef40022765398b58aa0a58d096"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77305e298b764b9d83a00f5bbf5c0e13c45f9a8da2b66c23501c5b0591e3edb7"
    sha256 cellar: :any_skip_relocation, ventura:        "4d9af1c0f867c91d991549c074003e4f01a59a5b6c91223660874e24bdbb1ea0"
    sha256 cellar: :any_skip_relocation, monterey:       "e9dd58e2c0b9834688aedb8d121e6b2d6998177f97ac2966b95947323c853e71"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d8b39a304f5a69d500fe3244828a89a36865432542b9f922749b1b61a53736b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb4324383a5e6592ce17a8451279f9fd458c973ac83f6949ddbbccf5ee63fa02"
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

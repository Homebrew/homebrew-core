class Nfpm < Formula
  desc "Simple deb and rpm packager"
  homepage "https://nfpm.goreleaser.com/"
  url "https://github.com/goreleaser/nfpm/archive/refs/tags/v2.36.1.tar.gz"
  sha256 "8ddc7c0f4ac35aa38bb2af81edbccec243092dd1d6991538fc14f7163791393d"
  license "MIT"
  head "https://github.com/goreleaser/nfpm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7310a97a17beb604accfd24fcf41e7fdd0e85d60afd0f46cf7de4a2f7308a9e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4214bede550e32fdd03fbd98220c658a1744af757eab1c8fa174ec6367ef926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c546257f337465598cee63a76ef491d2f18e63d3a791d0ddb11112971d0f338a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d58cb00623affa56f4cf0b65f8349119fd77425fe485115c342deacacf635fad"
    sha256 cellar: :any_skip_relocation, ventura:        "59abf1e8ad3404f418ac1d974cf849b65621246fb8a53f797efabf3ab520302c"
    sha256 cellar: :any_skip_relocation, monterey:       "12196236152092cd593b1761b656e7d790818755dbff9e0adb20a569679f31ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eea646cde3c81f57c9259662a867f862fd8f7e54ebe75a7093ca0cd8fefd2e4a"
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

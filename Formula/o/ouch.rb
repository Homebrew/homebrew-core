class Ouch < Formula
  desc "Painless compression and decompression for your terminal"
  homepage "https://github.com/ouch-org/ouch"
  url "https://github.com/ouch-org/ouch/archive/refs/tags/0.6.1.tar.gz"
  sha256 "e6265071affab228ba7d3ca85f2206029445038b3a3d96036e9bf02b795ad651"
  license "MIT"
  head "https://github.com/ouch-org/ouch.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e798b86b095e7f88bdf7ca263999a574fd8167f42964d9d57e4d490ebc6cbc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f738cabc9e3b008bc72416fbe7b594e0c204726b232d4688e33e38d26c30640"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a0ba83e6c42c8c5137b2c8dc106372017bf8641541225154deca97a8fd2d2b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "92caf7fc595680d7811e69ae09014aeaee688247180ae1cff6da1708dfbbb14b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce47dcc579ea3287f006936e98b11757410eb31405b980b2e0b24796193c1ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8714aac8dea1ebb10eca5cec43b397c6fa52e771f3c2ce69c206148598268f88"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # for completion and manpage generation
    ENV["OUCH_ARTIFACTS_FOLDER"] = buildpath

    system "cargo", "install", *std_cargo_args

    bash_completion.install "ouch.bash" => "ouch"
    fish_completion.install "ouch.fish"
    zsh_completion.install "_ouch"

    man1.install Dir["*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ouch --version")

    (testpath/"file1").write "Hello"
    (testpath/"file2").write "World!"

    %w[tar zip 7z tar.bz2 tar.bz3 tar.lz4 tar.gz tar.xz tar.zst tar.sz tar.br].each do |format|
      system bin/"ouch", "compress", "file1", "file2", "archive.#{format}"
      assert_path_exists testpath/"archive.#{format}"

      system bin/"ouch", "decompress", "-y", "archive.#{format}", "--dir", testpath/format
      assert_equal "Hello", (testpath/format/"file1").read
      assert_equal "World!", (testpath/format/"file2").read
    end
  end
end

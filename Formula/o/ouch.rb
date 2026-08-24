class Ouch < Formula
  desc "Painless compression and decompression for your terminal"
  homepage "https://github.com/ouch-org/ouch"
  url "https://github.com/ouch-org/ouch/archive/refs/tags/0.8.1.tar.gz"
  sha256 "920f73d4b162bd1814b67c57906b7322345f198d763f28d04722a406f8352246"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2be5acb76800c11b40c33b552cec563cdcd1c80c38c37aee1b79c20a67fbedc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dfd1193abd79e9b7dbb5c7a5b332a6fe5963b77873b8abb8f4ddd19a08ffa30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94b7ea1512e70d0b35a7a7f66f9d612b2507b579f7df7d670bce3bcb1f6c2b9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e5dbda1a06f9a352eebeaf5d754625379a4cecedffb14d0ee2fdda306f6bffe"
    sha256 cellar: :any,                 arm64_linux:   "9347ef7969b009a3208324110e6db6b6cdc36f2d80c956260ac8956d9b942a2a"
    sha256 cellar: :any,                 x86_64_linux:  "1f9234fd435a7a49fc3807a55f40b8a8db0a6f319ff32c26859002a6bee50c0a"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix release version metadata
  patch do
    url "https://github.com/ouch-org/ouch/commit/f85299603f3b7ac36671e5468e247bd5a845792b.patch?full_index=1"
    sha256 "5b697d3737bea5f0522ed8ecbbc17e928c04e1cebf9783e0fd766c3519afffce"
    type :unofficial
    resolves "https://github.com/ouch-org/ouch/pull/1019"
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

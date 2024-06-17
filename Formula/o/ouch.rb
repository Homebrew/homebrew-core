class Ouch < Formula
  desc "Painless compression and decompression for your terminal"
  homepage "https://github.com/ouch-org/ouch"
  url "https://github.com/ouch-org/ouch/archive/refs/tags/0.5.1.tar.gz"
  sha256 "46cc2b14f53de2f706436df59300eb90c5a58f08ac8c738fd976fcb8ec0cd335"
  license "MIT"
  head "https://github.com/ouch-org/ouch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96516fad49dade5fd195d9b6610c189750a29e19d8151b63d30e9bc5eed7ccb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "045659db08dc4821578de4fe5f31acf36bcbe46ef8112e5e10b283bbd0c9826a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5e4e6cf4f26e98a708f3f6d0d017d70dfbb60982c71e43bcad1abcab948ccc1"
    sha256 cellar: :any_skip_relocation, sonoma:         "120da005b6f47e606635590b7a6fe3d9d07e4a760dae9b9772121df9bdfae3ba"
    sha256 cellar: :any_skip_relocation, ventura:        "843b8b72bbc16e4b5be35d828964683aeacd965e269cdcff2fd331b1f1ac5cbb"
    sha256 cellar: :any_skip_relocation, monterey:       "6bf0d26001a16f01e235d1ff20b03d6992d58dc4ec990f2fb18ab42ed7bb028c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5f89e533cc7aab96e7261bf11b4016b13397c89757f3e2ed82865c1758a5cf2"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"file1").write "Hello"
    (testpath/"file2").write "World!"

    %w[tar zip tar.bz2 tar.gz tar.xz tar.zst].each do |format|
      system bin/"ouch", "compress", "file1", "file2", "archive.#{format}"
      assert_predicate testpath/"archive.#{format}", :exist?

      system bin/"ouch", "decompress", "-y", "archive.#{format}", "--dir", testpath/format
      assert_equal "Hello", (testpath/format/"archive/file1").read
      assert_equal "World!", (testpath/format/"archive/file2").read
    end
  end
end

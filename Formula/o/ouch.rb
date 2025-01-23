class Ouch < Formula
  desc "Painless compression and decompression for your terminal"
  homepage "https://github.com/ouch-org/ouch"
  url "https://github.com/ouch-org/ouch/archive/refs/tags/0.5.1.tar.gz"
  sha256 "46cc2b14f53de2f706436df59300eb90c5a58f08ac8c738fd976fcb8ec0cd335"
  license "MIT"
  head "https://github.com/ouch-org/ouch.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11795cbe9c38f30481e04282efceebe109de670689a346558585db7aa1ef0977"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "424a341aa2183e0fac3aa9180c88d0a293876bb077a6a07a9ab775dc4694abef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55fa180fa50d60cae20499315c094e4e27ef9569c7bc153e194da5981e4dae53"
    sha256 cellar: :any_skip_relocation, sonoma:        "e577a0daba8281df2106f823428d147e2b5feb5bd94c8a7bab428dda4cd5c269"
    sha256 cellar: :any_skip_relocation, ventura:       "ecd0d5ec186fddd2fc7f770c587428e9ca9f7606e8998af8353ad7bbe81a216b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75ebb0483051766284f4eb6cd08c3a117b63a6f6eeec6f369213c9340b5accfb"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "xz"
  uses_from_macos "zlib"

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

    %w[tar zip tar.bz2 tar.gz tar.xz tar.zst].each do |format|
      system bin/"ouch", "compress", "file1", "file2", "archive.#{format}"
      assert_predicate testpath/"archive.#{format}", :exist?

      system bin/"ouch", "decompress", "-y", "archive.#{format}", "--dir", testpath/format
      assert_equal "Hello", (testpath/format/"archive/file1").read
      assert_equal "World!", (testpath/format/"archive/file2").read
    end
  end
end

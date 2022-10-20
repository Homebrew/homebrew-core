class Ouch < Formula
  desc "Painless compression and decompression for your terminal"
  homepage "https://github.com/ouch-org/ouch"
  url "https://github.com/ouch-org/ouch/archive/refs/tags/0.3.1.tar.gz"
  sha256 "269abaf5ac2f80da3796dbf5e73419c1b64104d1295f3ff57965141f079e6f6d"
  license "MIT"
  head "https://github.com/ouch-org/ouch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a50b6a78f0c51e0c7980e8512f59656857427e7e3dc2a0eeae78e8d1493d72b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "814910019e9fbd5c6b2546ac4b053040900b261d263aee06af152a8da4f82585"
    sha256 cellar: :any_skip_relocation, monterey:       "a56fbc35f35b3cb277a67815ed627f5c70339b53c7b9c9806935844f3fd3eac3"
    sha256 cellar: :any_skip_relocation, big_sur:        "492fc5a573d4769b38779937283bcb6f95cd2be9e64b162d379c3fec74532424"
    sha256 cellar: :any_skip_relocation, catalina:       "fccc2c5f957ab41a45e0b0e8e18476c1e34f4554db994d070838626b316fe5a3"
  end

  depends_on "rust" => :build
  depends_on :macos # Doesn't build on Linux

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

      system bin/"ouch", "decompress", "archive.#{format}", "--dir", testpath/format
      assert_equal "Hello", (testpath/format/"file1").read
      assert_equal "World!", (testpath/format/"file2").read
    end
  end
end

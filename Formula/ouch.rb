class Ouch < Formula
  desc "Painless compression and decompression for your terminal"
  homepage "https://github.com/ouch-org/ouch"
  url "https://github.com/ouch-org/ouch/archive/refs/tags/0.4.0.tar.gz"
  sha256 "3e126f00e1ad82ef4abfd28f86dac53b366a29de6a70359e734ecc8748f580fc"
  license "MIT"
  head "https://github.com/ouch-org/ouch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca9889e3d434284b5fad2bc60e755334d069091e6816cf68142a7684c43ed7ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdd6e0a7dac20d0c1a121ba87998cd0feb7f2c135f69653b8168f4930f6b23ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60b8a7787461098f0a32fdac9a306031324d6721d1d132be42d08027f30958e4"
    sha256 cellar: :any_skip_relocation, monterey:       "0cb9d7ebc47575dfb1212e2709417490bfec5ebec96a9fe8330a5729fa784e97"
    sha256 cellar: :any_skip_relocation, big_sur:        "058c3cef527b86604e0b062600df742be5806d27a2c8570bf0cf5fdead3caeb6"
    sha256 cellar: :any_skip_relocation, catalina:       "dae85287b8bbc9a1d0cfa0b7ca76fb9c7030cd8302e221f337de9d5f37b34fdf"
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

      system bin/"ouch", "decompress", "-y", "archive.#{format}", "--dir", testpath/format
      assert_equal "Hello", (testpath/format/"archive/file1").read
      assert_equal "World!", (testpath/format/"archive/file2").read
    end
  end
end

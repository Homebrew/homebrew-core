class Ouch < Formula
  desc "Painless compression and decompression for your terminal"
  homepage "https://github.com/ouch-org/ouch"
  url "https://github.com/ouch-org/ouch/archive/refs/tags/0.4.1.tar.gz"
  sha256 "b0fcd6bbe6c66544b5bf1167d72605427c5cc6afae564f23f3eff5ea22b01b79"
  license "MIT"
  head "https://github.com/ouch-org/ouch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "245bdb652a2d45dc46cdbeef3ac7b777f2cd6cd068d2f46b0748e9c4275bb866"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c2d4175eb2bb0b53e76d836026bf70d3444478f5b4d83a36433fb3eae8c703d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "417850ab47030112e2dd445e5c99deb7a4cb7189281620b574a968abda0063a4"
    sha256 cellar: :any_skip_relocation, ventura:        "aa447b270e120c279a5412a41e769725e5f1b9b6c876e9b7e9d26e0604b25042"
    sha256 cellar: :any_skip_relocation, monterey:       "68dd3c0e779e63ded96fd57b6f04a67fd305ff3f69071653329896fc9229df84"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b4f86dabc95a6cb8f18dbd6a21e0da66c0b5f37fd33540faf5e4fa21cec9ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4264c67dbed580fd1246969d25f1895fd396d9f3154fdd0e6f24115fe5abbd23"
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

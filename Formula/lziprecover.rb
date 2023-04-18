class Lziprecover < Formula
  desc "Data recovery tool and decompressor for files in the lzip compressed data format"
  homepage "https://www.nongnu.org/lzip/lziprecover.html"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lziprecover/lziprecover-1.23.tar.gz"
  sha256 "f29804177f06dd51c3fa52615ae198a76002b6ce8d961c3575546c3740f4b572"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lziprecover/"
    regex(/href=.*?lziprecover[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47ea60a44899e5833b8bd0b4daa3e037802ff53681e1cedf6b6acae3d306a5ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f304f75f053a6045e0286da2f1761c1a5c73c0333c80446017b8f7a3519b66e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e750fd2418477ae083f1be0113572af5703d0997971871e046db90450530d4e1"
    sha256 cellar: :any_skip_relocation, ventura:        "26cbe75e810889f787a764ebc8d9ee13327876f0428e0f3e9f4f8b7efab2adf9"
    sha256 cellar: :any_skip_relocation, monterey:       "f85eac960d6a8a1a8fcf3711980fb9122e1cd4789161c7d974840c2d1762e650"
    sha256 cellar: :any_skip_relocation, big_sur:        "0180531f07c7493e58ef145c7de2ee0891db6ec8c2d2a24ca62cad813c5ea95d"
    sha256 cellar: :any_skip_relocation, catalina:       "5e2168438e6bd3669db3dae1969173737873f46372003ae36a56d832296e5e45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61b9cb353269182c3ba0564849ac427d35735389270c565eadc55e8c4b2dfd70"
  end

  depends_on "lzip" => :test

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    filename = "data.txt"
    fixed_filename = "#{filename}_fixed"
    path = testpath/filename
    fixed_path = testpath/fixed_filename

    original_contents = "." * 1000
    path.write original_contents

    # Compress data into archive
    system Formula["lzip"].opt_bin/"lzip", path
    refute_predicate path, :exist?

    # Corrupt the archive to test the recovery process
    File.open("#{path}.lz", "r+b") do |file|
      file.seek(7)
      data = file.read(1).unpack1("C*")
      data = ~data
      file.write([data].pack("C*"))
    end

    # Verify that file corruption is detected
    assert_match "Decoder error", shell_output("#{bin}/lziprecover -t #{path}.lz 2>&1", 2)

    # Attempt to recover the corrupted archive
    system bin/"lziprecover", "-R", "#{path}.lz"

    # Verify that recovered data is unchanged
    system bin/"lziprecover", "-d", "#{fixed_path}.lz"
    assert_equal original_contents, fixed_path.read
  end
end

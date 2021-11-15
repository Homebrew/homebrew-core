class Lziprecover < Formula
  desc "Data recovery tool and decompressor for files in the lzip compressed data format"
  homepage "https://www.nongnu.org/lzip/lziprecover.html"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lziprecover/lziprecover-1.22.tar.gz"
  sha256 "fd958a0975f7729c44f3b784e566891f736c3dc68374dbd2149ee692a16d0862"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lziprecover/"
    regex(/href=.*?lziprecover[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc1c3df3a5469043489e995ffa7e7bc450df1eff70a52227a0d01de08c858f64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1619cf04484327e4a674f51a54c18f69212908483f5aeeef3ce553997058dbfb"
    sha256 cellar: :any_skip_relocation, monterey:       "df55329c9f991f485d01cb0459f31e3d9717f83e8fff5947b94cc45f57aeab87"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcf5e375245c6fabe48f084846c055c66065af4575027f05a81a5e33ef931a57"
    sha256 cellar: :any_skip_relocation, catalina:       "f99984733bd12d57d31bda428f03c9603a01f3b33aa1e83cfae464bf5db6fd0e"
    sha256 cellar: :any_skip_relocation, mojave:         "7cd81f75c35b9ff4e27b60780bdf5503a6e986c94a3772c6493b9cd490dc6a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d39f36865f6a9f5c8c4e701534ea500d2b900a1d38b7a455ffb0fd977a23ce81"
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

class Lziprecover < Formula
  desc "Data recovery tool and decompressor for files in the lzip compressed data format"
  homepage "https://www.nongnu.org/lzip/lziprecover.html"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lziprecover/lziprecover-1.26.tar.gz"
  sha256 "e234005a756d5649f41686116d3e548736d4a77e5a5ec37b943ca6650787801d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lziprecover/"
    regex(/href=.*?lziprecover[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "343f6706d13abac08b7b069f83c3cda00a7b3c7ebd15be78e9a476786665463f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a8b035e1cef46df76a525692bd88f3dad688650f4bf63e4acec4c43ffd2a75a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "775876ff0175a9cf9246ba86b165db3e116f6537adeb7105f1e8e2eff76276f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "09759201cdfab6f46d9e97f15cd893d4f10b0c1efe1fc650356e472062af2cd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d454115600543232b210e45c247bf103dde666cdf725509139da843899ab6ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66cbf0d8af517659c8df84822d8a6d763c09cbd21c52882c1957073ce594a37f"
  end

  depends_on "lzip" => :test

  def install
    system "./configure", *std_configure_args
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
    refute_path_exists path

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
    system bin/"lziprecover", "-B", "#{path}.lz"

    # Verify that recovered data is unchanged
    system bin/"lziprecover", "-d", "#{fixed_path}.lz"
    assert_equal original_contents, fixed_path.read
  end
end

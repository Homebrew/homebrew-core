class Lziprecover < Formula
  desc "Data recovery tool and decompressor for files in the lzip compressed data format"
  homepage "https://www.nongnu.org/lzip/lziprecover.html"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lziprecover/lziprecover-1.25.tar.gz"
  sha256 "4f392f9c780ae266ee3d0db166b0f1b4d3ae07076e401dc2b199dc3a0fff8b45"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lziprecover/"
    regex(/href=.*?lziprecover[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9152484be560c150f17cd3e34e235a5a4e8efce5f2d7eac6f7a02d671fd7b360"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9dfd6b15c1d4d1ab02c6aed05ef8ca2b6f21bb9ffd5feed204c06ec606b6770"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd20c214e86a0a66aafe279db858e5806a775567490e22a92f68c2048dfe5728"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddd6ef5287bb52ddc1b4140743e599d6cb821971f3b824e668da2dd9532dfad3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1965cecf72d16347675ff1f64c278d4fb723e65a505981583d0d5efae7ac0f78"
    sha256 cellar: :any_skip_relocation, ventura:       "aaba0e8d69a176034618c16c1926e522665fbe7ebfdef634dd22a63302e0c47e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bcf5ca43c008386255623253b393737a1be103f63c617a65eed8c77892320f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3f14cf600fd5f4353371429ab79056f48c7f42c95868bd9332a29059b64fa4d"
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

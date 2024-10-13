class Lziprecover < Formula
  desc "Data recovery tool and decompressor for files in the lzip compressed data format"
  homepage "https://www.nongnu.org/lzip/lziprecover.html"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lziprecover/lziprecover-1.24.tar.gz"
  sha256 "1d699cfaefe92eb2624a3652580bcafe0bbb98fe7818c25e6de823bcdd0d458f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lziprecover/"
    regex(/href=.*?lziprecover[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4a2dd650f45782dcc8de128bd7015097c5dfa9a4e4a2e306ff96cf8c1fef1e2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92fb61b39ad982dcefcf73afb6a005208156b9909cdcb7b3e5def6158589336c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25f136fe7fe5b7565373debbae2ea9efc280c140ca82f1f01e64be2bb9cf087b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17f6b6deabe434ae8fd3ee061a07847f0146f38d786fb46b53917b658eab0d5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "11dfdffe42cf0c75cd15acd369336a80569a57e14f83a42c0fd0f31c0707b2f2"
    sha256 cellar: :any_skip_relocation, ventura:        "0324acbac4ee097f0a9ebcf2fefe3b30dbe654b55baa70fe63241dcd89075e89"
    sha256 cellar: :any_skip_relocation, monterey:       "9c9949fa4537af00f21ff19e58616a54565c6f2118a843472aab12af1c2ec9d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6df153d89b7704c4920d7419815b7804aca753067b1984bc7711c3d748d994d8"
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

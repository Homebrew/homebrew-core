class Lunzip < Formula
  desc "Decompressor for lzip files"
  homepage "https://www.nongnu.org/lzip/lunzip.html"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lunzip/lunzip-1.14.tar.gz"
  sha256 "70a30ca88c538b074a04a6d5fa12a57f8e89febcb9145d322e9525f3694e4cb0"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lunzip/"
    regex(/href=.*?lunzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0c2a4ab213f104a7cf35f3b6185a22b34aee823ba4365d61d07673d76c331321"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b230466f83c116406a40d69f52a03609adb66a4f04195e6056989495bc4bfb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3de34eb3bf231ce9f3c3d7837e1375f03d67451da7b10999f41ec1295ab4154"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "767465b8ee2df577b48e8dded31e30f985afca3d22bea32878ea935da69b9b33"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a2fdb825b6c45b1ef097af60fd5328973bd837d26a07071c69724d1ce70d0d5"
    sha256 cellar: :any_skip_relocation, ventura:        "0ecb253dd633ce9d75b4421afedc85557d703187f391e7b51450b7fc1f597af6"
    sha256 cellar: :any_skip_relocation, monterey:       "5ced2c2240a634e7d9eae2075567e66a6b3d8f49c6327ab337e8d1de5030c947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97e9a719aabd86d8e39349c4e91959834baef1d75b3128a9fbd28f7ad631416f"
  end

  depends_on "lzip" => :test

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lz
    system Formula["lzip"].opt_bin/"lzip", path
    refute_predicate path, :exist?

    # decompress: data.txt.lz -> data.txt
    system bin/"lunzip", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end

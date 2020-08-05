class Dsh < Formula
  desc "Dancer's shell, or distributed shell"
  homepage "https://www.netfort.gr.jp/~dancer/software/dsh.html.en"
  url "https://www.netfort.gr.jp/~dancer/software/downloads/dsh-0.25.10.tar.gz"
  sha256 "520031a5474c25c6b3f9a0840e06a4fea4750734043ab06342522f533fa5b4d0"

  bottle do
    sha256 "e978724605a216f2e3ffc5df3ba12bb53e3150aa63b7d18779723e563a35f867" => :mojave
    sha256 "5d553941319eae8d839a53063057fff05b359eb13e53da2d7313c3d41fae88b0" => :high_sierra
    sha256 "9d694a476e5d74d7c3edbf284628e3f68c96c5a30c91b7fd3c624630805636ea" => :sierra
    sha256 "0b6a147235228473634c424e5e12671b6e9a4609ce6b732dd5ca9f56f335add5" => :el_capitan
    sha256 "fba83e836f8fa0ddca0a9c35f5f8781aabb0a3c7dfadc8eb6cd69ca1e2930cd0" => :yosemite
  end

  depends_on "libdshconfig"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

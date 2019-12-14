class Bashdb < Formula
  desc "Bash shell debugger"
  homepage "https://bashdb.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bashdb/bashdb/5.0-1.1.2/bashdb-5.0-1.1.2.tar.bz2"
  version "5.0-1.1.2"
  sha256 "30176d2ad28c5b00b2e2d21c5ea1aef8fbaf40a8f9d9f723c67c60531f3b7330"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf1398e390505425398d0c5b8d4c00eadbc2f6f89a79f5c2fd49b7bb39627422" => :mojave
    sha256 "b28d68c233e0aeea8c1f690d60ad4ab3a3a861f3479a0c9910ea38c7930beb04" => :high_sierra
    sha256 "c16468585dfc75cdc28379afdbd5a506e7a842be3cbbb91249063b614b6ab94f" => :sierra
    sha256 "c16468585dfc75cdc28379afdbd5a506e7a842be3cbbb91249063b614b6ab94f" => :el_capitan
    sha256 "c16468585dfc75cdc28379afdbd5a506e7a842be3cbbb91249063b614b6ab94f" => :yosemite
  end

  depends_on "bash"

  def install
    system "./configure", "--with-bash=#{HOMEBREW_PREFIX}/bin/bash",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/bashdb --version 2>&1")
  end
end

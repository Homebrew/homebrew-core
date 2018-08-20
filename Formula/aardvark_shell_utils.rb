class AardvarkShellUtils < Formula
  desc "Utilities to aid shell scripts or command-line users"
  homepage "http://www.laffeycomputer.com/shellutils.html"
  url "http://downloads.laffeycomputer.com/current_builds/shellutils/aardvark_shell_utils-1.0.tar.gz"
  sha256 "aa2b83d9eea416aa31dd1ce9b04054be1a504e60e46426225543476c0ebc3f67"

  bottle do
    cellar :any_skip_relocation
    sha256 "d67eb7992219f30e6bced8b4a47d4a111ebb81b6b622d33dfb73ce2022b4fb70" => :mojave
    sha256 "aec60722076aab148a97d2f426f7d15b1b214793f8168b15f2b6d4d65d2afc48" => :high_sierra
    sha256 "cf6d9a3d99fefa3cce7ea67c7e8070a99d648b5bf3a3cd9da9ab128a1696327d" => :sierra
    sha256 "4fc19fca9729b408c5a77f362fff72a8c74c324d4a81cc0cf3e4c91b41bf2d6f" => :el_capitan
    sha256 "ca1cb774102a7e5128f964c2c9d48b45877f1fd3347288edb2adef5981fdd0f4" => :yosemite
    sha256 "e8e8b6fd4ee85d8a6ae267fbd20160c1aeddeb6c8e302793b12a807131ef4b27" => :mavericks
  end

  conflicts_with "coreutils", :because => "both install `realpath` binaries"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "movcpm", shell_output("#{bin}/filebase movcpm.com").strip
    assert_equal "com", shell_output("#{bin}/fileext movcpm.com").strip
    assert_equal testpath.realpath.to_s, shell_output("#{bin}/realpath .").strip
  end
end

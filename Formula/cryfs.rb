class Cryfs < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.9.8/cryfs-0.9.8.tar.xz"
  sha256 "e4669aa79f8d419bb2580121a118b8993ee3493a08c5b1e0b80b8a8a4b54da65"
  revision 1
  head "https://github.com/cryfs/cryfs.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "d2a0b33bad6a416f58c8f40de8e24d20ece1166f5fddf1ba8fb834d0abc5125b" => :high_sierra
    sha256 "08c34dced2289713c82db9a02765b0df2cad7e8fbc7450b838b6fecbb4353b59" => :sierra
    sha256 "4366699f70085fe9bd2dee3303c06c2bcabb41b51d579f4280bcc8edcdcdfb11" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cryptopp"
  depends_on "openssl"
  depends_on :osxfuse

  needs :cxx11

  def install
    system "cmake", ".", "-DBUILD_TESTING=off", *std_cmake_args
    system "make", "install"
  end

  test do
    ENV["CRYFS_FRONTEND"] = "noninteractive"
    assert_match "CryFS", shell_output("#{bin}/cryfs", 1)
  end
end

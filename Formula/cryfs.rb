class Cryfs < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.9.8/cryfs-0.9.8.tar.xz"
  sha256 "e4669aa79f8d419bb2580121a118b8993ee3493a08c5b1e0b80b8a8a4b54da65"
  head "https://github.com/cryfs/cryfs.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "c6d716d9604086faa8aa64d64836d3c1c20674d94e203d98ea643202a5afd547" => :high_sierra
    sha256 "ed69c7628756a2db65cdd0720c97f329de632dc8fb295615b22b351fe774623a" => :sierra
    sha256 "8e3be5b7d701349d3d4e2ebb072320abd3d09f4b7a42a68e292878279a83c20b" => :el_capitan
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

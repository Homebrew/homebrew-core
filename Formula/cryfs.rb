class Cryfs < Formula
  desc "Encrypts your files, so you can safely store them in Dropbox, iCloud, ..."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.9.7/cryfs-0.9.7.tar.xz"
  sha256 "c998069217c29c026a944da47eea0a9e73eda914ef0f891f436701bcbdbbe4d7"
  head "https://github.com/cryfs/cryfs.git", :branch => "develop"

  bottle do
    cellar :any
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

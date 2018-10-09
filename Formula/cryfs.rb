class Cryfs < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.9.9/cryfs-0.9.9.tar.xz"
  sha256 "aa8d90bb4c821cf8347f0f4cbc5f68a1e0f4eb461ffd8f1ee093c4d37eac2908"

  bottle do
    cellar :any
    sha256 "9ad2ecacb4813c16b2b706d4cf6b4348ff86ef019fe6c5a7d9c39fb418010c46" => :mojave
    sha256 "8f58cac3f867d51a95f09e17e15b893dc4415df18476963dd8cdd72c9a99f56c" => :high_sierra
    sha256 "db97f7cd1d28b3036165d4f8142688b73e3bce12416d0a1a0b9eff03d44a0245" => :sierra
    sha256 "2fab8415b94e7b2f782ec642e2e4fb0ce345524f5fd014cc21d14b2b410c8635" => :el_capitan
  end

  head do
    url "https://github.com/cryfs/cryfs.git", :branch => "develop", :shallow => false
    depends_on "libomp"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cryptopp"
  depends_on "openssl"
  depends_on :osxfuse

  needs :cxx11

  def install
    configure_args = [
      "-DBUILD_TESTING=off",
    ]

    if build.head?
      libomp = Formula["libomp"]
      configure_args.concat(
        [
          "-DOpenMP_CXX_FLAGS='-Xpreprocessor -fopenmp -I#{libomp.include}'",
          "-DOpenMP_CXX_LIB_NAMES=omp",
          "-DOpenMP_omp_LIBRARY=#{libomp.lib}/libomp.dylib",
        ],
      )
    end

    system "cmake", ".", *configure_args, *std_cmake_args
    system "make", "install"
  end

  test do
    ENV["CRYFS_FRONTEND"] = "noninteractive"
    assert_match "CryFS", shell_output("#{bin}/cryfs", 10)
  end
end

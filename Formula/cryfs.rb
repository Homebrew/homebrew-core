class Cryfs < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.9.10/cryfs-0.9.10.tar.xz"
  sha256 "a2b3b401c0d709fd7c2fc2c35e9decda204dfe7e7ac6b84044d7698780599d24"

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

    # Test showing help page
    assert_match "CryFS", shell_output("#{bin}/cryfs 2>&1", 10)

    # Test mounting a filesystem. This command will ultimately fail because homebrew tests
    # don't have the required permissions to mount fuse filesystems, but before that
    # it should display "Mounting filesystem". If that doesn't happen, there's something
    # wrong. For example there was an ABI incompatibility issue between the crypto++ version
    # the cryfs bottle was compiled with and the crypto++ library installed by homebrew to.
    Dir.mkdir("basedir")
    Dir.mkdir("mountdir")
    assert_match "Mounting filesystem", pipe_output("#{bin}/cryfs -f basedir mountdir 2>&1", "password")
  end
end

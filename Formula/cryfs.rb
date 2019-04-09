class Cryfs < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.10.1/cryfs-0.10.1.tar.xz"
  sha256 "be7a9bb550e1bd5fc0f009ba61b8d0df161fbd8b2db48a746f99238a752ce69a"

  bottle do
    cellar :any
    sha256 "aa52518edcf8edc3707ceb8081483606c3878d1e1087a0f392ee694e6680a576" => :mojave
    sha256 "24c8beaf4992fd001a98a6b0fbd9da75e2293e22a482edb62070d136a1fe93af" => :high_sierra
    sha256 "1c142ea0d1ed5ccfb895ceec992d91bde06cee5deee13c963b898d39d4881d55" => :sierra
  end

  head do
    url "https://github.com/cryfs/cryfs.git", :branch => "develop", :shallow => false
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libomp"
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
    mkdir "basedir"
    mkdir "mountdir"
    assert_match "Operation not permitted", pipe_output("#{bin}/cryfs -f basedir mountdir 2>&1", "password")
  end
end

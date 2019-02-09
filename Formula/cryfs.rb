class Cryfs < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.10.0/cryfs-0.10.0.tar.xz"
  sha256 "2413b76ad73026eb166c72c2081d303eafe2357d6a981618765fc4720281e52b"

  bottle do
    cellar :any
    sha256 "4637872ef228da6384a3fadf194497eb2feaebdbe3c87acc7edb03286d1fef91" => :mojave
    sha256 "af925dd1478d3f2ec79d4534104071ec61d8465aef83a7252ff1ea0b085462e2" => :high_sierra
    sha256 "3ec5a26b681faf31a91eb2d64b079dd68d09506552788ffd528d5f80aa748a5a" => :sierra
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

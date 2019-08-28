class Cryfs < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.10.2/cryfs-0.10.2.tar.xz"
  sha256 "5531351b67ea23f849b71a1bc44474015c5718d1acce039cf101d321b27f03d5"

  bottle do
    cellar :any
    sha256 "acff4a7b949564ac16af311b5083043a59913b943d71644921274c9a6045fa82" => :mojave
    sha256 "8883d9b7280e3571a55b71742e2c74f20f8fab76199b672aec593f873be8f78c" => :high_sierra
    sha256 "d137fb4584254f3e8be128c50aeb9cb7e2b4912a2227517334485460d2ec5340" => :sierra
  end

  head do
    url "https://github.com/cryfs/cryfs.git", :branch => "develop", :shallow => false
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libomp"
  depends_on "openssl@1.1"
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

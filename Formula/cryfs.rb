class Cryfs < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.9.10/cryfs-0.9.10.tar.xz"
  sha256 "a2b3b401c0d709fd7c2fc2c35e9decda204dfe7e7ac6b84044d7698780599d24"

  bottle do
    cellar :any
    sha256 "31079d98686f57a32d321a79692b6ea604cead945bade8dade38974e9f710c73" => :mojave
    sha256 "54cd58c05a44074d342b2a29f1b3b9c812f1ebe6e9063f3b878bf27b646450ed" => :high_sierra
    sha256 "9d0edae77eafd3ac6d4431c45842b3b9eeff12b12fcac588403bf96505381170" => :sierra
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

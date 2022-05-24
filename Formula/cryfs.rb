class Cryfs < Formula
  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.10.2/cryfs-0.10.2.tar.xz"
  sha256 "5531351b67ea23f849b71a1bc44474015c5718d1acce039cf101d321b27f03d5"
  license "LGPL-3.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, catalina:    "3a5986dc3775877188cbf4442bd72c6f20ffe1d384fefebac8041c0d8f9ff09b"
    sha256 cellar: :any, mojave:      "cc94e5ba2d13205b0199e59779cecd7dd094965ee22c4ebf92d53ecaa65f8be7"
    sha256 cellar: :any, high_sierra: "daa6d8961ef98fc509e806614c4daf6f589ee7d76bbb483066962b6bd700a2fe"
    sha256 cellar: :any, sierra:      "252aa90f3281ccff1b9d0c6292856df1a08be17ada7aacd320f05d2d2508565f"
  end

  head do
    url "https://github.com/cryfs/cryfs.git", branch: "develop"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libomp"
  depends_on "openssl@1.1"

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse"
  end

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

  def caveats
    on_macos do
      <<~EOS
        The reasons for disabling this formula can be found here:
          https://github.com/Homebrew/homebrew-core/pull/64491

        An external tap may provide a replacement formula. See:
          https://docs.brew.sh/Interesting-Taps-and-Forks
      EOS
    end
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

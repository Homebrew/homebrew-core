class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/bdwgc/libatomic_ops/"
  url "https://github.com/bdwgc/libatomic_ops/releases/download/v7.10.0/libatomic_ops-7.10.0.tar.gz"
  sha256 "0db3ebff755db170f65e74a64ec4511812e9ee3185c232eeffeacd274190dfb0"
  license all_of: [
    "MIT",
    "Boehm-GC",         # include/atomic_ops/sysdeps/gcc/
    "GPL-2.0-or-later", # lib/libatomic_ops_gpl.*
  ]
  head "https://github.com/bdwgc/libatomic_ops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "3248b78c7c787a075c8f8b94d7aebebb19f078352a302f0c014809fbb563c7e5"
    sha256 cellar: :any, arm64_sequoia: "cf518c8ee38c9ad886165accc2c3ed5b4dffa99f95ee58c737ab375e2c2c02a5"
    sha256 cellar: :any, arm64_sonoma:  "ef2dad1436dccb313a89eececf1237ce9a824372b7980322775624e15f991587"
    sha256 cellar: :any, sonoma:        "49f7a54247d1c918a747f8201a535edd9895268aac91f90ff25cdf52222fe709"
    sha256 cellar: :any, arm64_linux:   "297ecee2246dafa946f78d6c5bcb66d58346f418ae2cafb6419cdc3a4447023d"
    sha256 cellar: :any, x86_64_linux:  "07762d801e2f011b5be65fb4b19ae5a0becd151acab4964f4e47f1eb71d1d79a"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DAO_BUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-Dbuild_tests=ON",
                    *std_cmake_args,
                    "-DBUILD_TESTING=ON" # Pass this last to override `std_cmake_args`
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build",
                    "--parallel", ENV.make_jobs,
                    "--rerun-failed",
                    "--output-on-failure"
    system "cmake", "--install", "build"
  end
end

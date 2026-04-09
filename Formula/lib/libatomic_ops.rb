class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/bdwgc/libatomic_ops/"
  url "https://github.com/bdwgc/libatomic_ops/releases/download/v7.10.0/libatomic_ops-7.10.0.tar.gz"
  sha256 "0db3ebff755db170f65e74a64ec4511812e9ee3185c232eeffeacd274190dfb0"
  license all_of: ["GPL-2.0-or-later", "MIT"]
  head "https://github.com/bdwgc/libatomic_ops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b3dae32f7ff10faaa84a3a5ee3486cf65496feb75519dcaa2cf2d171be73fd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4378fe1188ad59424d8f452c9123fd04d117a44644a94ba8cc6376a6dcee2a00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81c1175fc0dc5c6c001328997b805cb39be52690b3609df78ccead64b655f694"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab9bc50267eab633db6d61166db93be0e5bf365b09106e1aeaaf581c093f3c46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "241c6cae391092c83e9d29d593085476df8ace090d633578d7e387bbbe730765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11be1a0fc988f891a83af51dcaa1712b17e4475acf92abf19f4f15a7ae92364e"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
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

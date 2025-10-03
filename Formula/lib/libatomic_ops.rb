class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/bdwgc/libatomic_ops/"
  url "https://github.com/bdwgc/libatomic_ops/releases/download/v7.8.4/libatomic_ops-7.8.4.tar.gz"
  sha256 "2356e002e80ef695875e971d6a4fd8c61ca5c6fa4fd1bf31cce54a269c8bfcd5"
  license all_of: ["GPL-2.0-or-later", "MIT"]
  head "https://github.com/bdwgc/libatomic_ops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b35d20b9a9f01c1a7b115b1aa74a7676f0737383b3d391e91b7272a58ff4902"
    sha256 cellar: :any,                 arm64_sequoia: "6db0b93459945fdc338138364b1b35e7529dc75c6040216934c8cb6320055c51"
    sha256 cellar: :any,                 arm64_sonoma:  "f78f714dbd114495d19a8da331eb4fd7725c7d3cf000285a40cfc824a5d34bef"
    sha256 cellar: :any,                 arm64_ventura: "2754abd7cdb11446d6f9621e126df341fd98dbf06b07853f8f314469b5c74a5e"
    sha256 cellar: :any,                 sonoma:        "b728e6b5fbaf5f16dc8d96fa2571928dd81d4201b2edb6e59420ed49a77746b1"
    sha256 cellar: :any,                 ventura:       "d3fe9707a966374d76581696952651843bdb8d1c3d866ca9e10a7632bf3a3ca9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33efd752c43a582af745c79abf29d4e7cd5183ec7649f378f29477acd5b7611f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a759ccaad62a2cea05d353353d2212bbe8c76241821fbd148b672db6a4e98944"
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

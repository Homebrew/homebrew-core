class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/refs/tags/boost-1.90.0.tar.gz"
  sha256 "e7b6a6daf91ecb1ac036d659280b8d7f1b3c50728cb4b205ae33baf6cd9b016a"
  license "BSL-1.0"
  version_scheme 1
  head "https://github.com/boostorg/build.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^boost[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d99b2722089128220de57924c1cc3b92aa9d2aaad47ad94e4653ea4a0e76db3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d3d8735ec4bc96fee878b78bea34d8f4c1f873d661d0128eaf15396eafc36ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6887afc5456043b371c0cb301ba7a9cf284483705e6057bc70b1870e606d539a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d2954beea42cc8679ac98500ec9d9aee4e2b51797598ee7c68581cea310a82a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c70e6871a6d978fa90d943e0502639ac738a5dd1ab2428ff84449aacd9cbe6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b899989a117bc0a5c9779703517038c4e5af07656ffdbf0b8a8c176943ad49f2"
  end

  conflicts_with "b2-tools", because: "both install `b2` binaries"

  def install
    system "./bootstrap.sh"
    system "./b2", "--prefix=#{prefix}", "install"
  end

  test do
    (testpath/"hello.cpp").write <<~CPP
      #include <iostream>
      int main (void) { std::cout << "Hello world"; }
    CPP
    (testpath/"Jamroot.jam").write <<~JAM
      exe hello : hello.cpp ;
      install install-bin : hello : <location>"#{testpath}" ;
    JAM

    system bin/"b2", "release"
    assert_path_exists testpath/"hello"
    assert_equal "Hello world", shell_output("./hello")
  end
end

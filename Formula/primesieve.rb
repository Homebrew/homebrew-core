class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/v7.6.tar.gz"
  sha256 "485669e8f9a6c74e528947d274df705f13caaf276d460d0f037b8dbc0c9c0a99"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6d083a698b7539f071069f19c2bab247072d83ae74132f952f8bd64ec9fb1a42"
    sha256 cellar: :any,                 arm64_big_sur:  "09fe5910556338d4a54649ca54e2188dbd158c66e08ecf673b94de694c423956"
    sha256 cellar: :any,                 monterey:       "16456c71979a5d6a89213577bb65d9856b513c89285a269f484c65af9b33e545"
    sha256 cellar: :any,                 big_sur:        "50ab785aea91644c88fae8d3a75118dbebd2206a99942d1dd5d813df5afd1d56"
    sha256 cellar: :any,                 catalina:       "46b89a5aebe93c324af325e1a4f15dd84a334564569c5a6816f998396289192c"
    sha256 cellar: :any,                 mojave:         "379ba3585b2ac86f43f58654ee9c8d9bc8e552bfda6d3b476399744880f85f2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53f9b8899168e786d258c628223aa9d0c18776001dbd75b69428187179eceb2d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end

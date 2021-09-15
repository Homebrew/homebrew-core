class Logswan < Formula
  desc "Fast Web log analyzer using probabilistic data structures"
  homepage "https://www.logswan.org"
  url "https://github.com/fcambus/logswan/archive/2.1.10.tar.gz"
  sha256 "561027c1aa5ddc87dac43df9fa74b2009ba6b75c5512f83e2c48105e4624e3cc"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "23442a9f241288d9733861abfca7cd6b3f99ce66b8787ec18799810731bba602"
    sha256 cellar: :any,                 big_sur:       "68760ddf896f317d44496728987da7255c40f4ccc3612c40fd13dbb33f2d6662"
    sha256 cellar: :any,                 catalina:      "b1eab00c396357a4d123a6747827774dab732d6d2e56e85fb9a32c7b22989cc2"
    sha256 cellar: :any,                 mojave:        "914eaff19cac1e0e58bf0d61fc23d089f69b405e7d35d95b818ef0b6c2968840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b52e7243534aaa15c17a110660d12984d5f89b5ca924994ec20540da2a09caca"
  end

  depends_on "cmake" => :build
  depends_on "jansson"
  depends_on "libmaxminddb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    assert_match "visits", shell_output("#{bin}/logswan #{pkgshare}/examples/logswan.log")
  end
end

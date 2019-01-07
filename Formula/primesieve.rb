class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://primesieve.org/"
  url "https://github.com/kimwalisch/primesieve/archive/v7.3.tar.gz"
  sha256 "bbf4a068ba220a479f3b6895513a85ab25f6b1dcbd690b188032c2c3482ef050"

  bottle do
    cellar :any
    sha256 "92f43249af5b48778cc626946c88491e12b7bf7877525570cb453a20183331b6" => :mojave
    sha256 "21426a2ed0959b3365e2e4544cdf41a128a048e181c3f5a006a72387dc91a6c2" => :high_sierra
    sha256 "535de3723bfa9ceb83a207c6a0c9ba25fd5b0b91cae7add58f2de749d37484f6" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end

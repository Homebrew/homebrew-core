class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/v7.6.tar.gz"
  sha256 "485669e8f9a6c74e528947d274df705f13caaf276d460d0f037b8dbc0c9c0a99"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 big_sur:      "50ab785aea91644c88fae8d3a75118dbebd2206a99942d1dd5d813df5afd1d56"
    sha256 cellar: :any,                 catalina:     "46b89a5aebe93c324af325e1a4f15dd84a334564569c5a6816f998396289192c"
    sha256 cellar: :any,                 mojave:       "379ba3585b2ac86f43f58654ee9c8d9bc8e552bfda6d3b476399744880f85f2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "53f9b8899168e786d258c628223aa9d0c18776001dbd75b69428187179eceb2d"
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

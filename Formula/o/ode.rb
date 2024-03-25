class Ode < Formula
  desc "Simulating articulated rigid body dynamics"
  homepage "https://www.ode.org/"
  url "https://bitbucket.org/odedevs/ode/downloads/ode-0.16.5.tar.gz"
  sha256 "ba875edd164570958795eeaa70f14853bfc34cc9871f8adde8da47e12bd54679"
  license any_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]
  head "https://bitbucket.org/odedevs/ode.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6cfb73fcdaa9bf73ecfd3763bcdf7d5a8ccd7639a0f9fe7a5da5067774b2f52a"
    sha256 cellar: :any,                 arm64_ventura:  "0db659d5d8b9f5b0a8391e07bf6dce76c6528ee142ef64227d27cd108c14fe76"
    sha256 cellar: :any,                 arm64_monterey: "2eb1e7ae85cec1e9d3686113190d8ec89fca460c58b81f3e978b20961d235cf6"
    sha256 cellar: :any,                 arm64_big_sur:  "f4cb558f0e993040046a0400a5d6aa69bd4916d5cac25e45597f2b6b72cbdb83"
    sha256 cellar: :any,                 sonoma:         "8220eec9e9f7cb97a01f3126ebf7f9365a98d9e02113e5bf98199cff3b65a4ba"
    sha256 cellar: :any,                 ventura:        "e04a88ce07030af5f9f93f2bd035a4b89ea200a9d67a17ebd89c7ad5bc536565"
    sha256 cellar: :any,                 monterey:       "af90730fce7e61597be9dd2132e985386a47e59dde6ba23a16c42d4e6a0d44f2"
    sha256 cellar: :any,                 big_sur:        "21c78389a6a1999ea1c0a5deb90e779ae44cbe71affcc7b6c5ac5ce0d43af578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26dc057f117efea645ebf883369d7d48082b6a87a40443ad95e2d40f26d2ff48"
  end

  depends_on "cmake" => :build
  depends_on "libccd"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    args = []
    args << "-DOPENGL_INCLUDE_DIR=#{Formula["mesa"].include}" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ode/ode.h>
      int main() {
        dInitODE();
        dCloseODE();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}/ode", "-L#{lib}", "-lode",
                   "-L#{Formula["libccd"].opt_lib}", "-lccd", "-lm", "-lpthread",
                   "-o", "test"
    system "./test"
  end
end

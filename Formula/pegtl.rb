class Pegtl < Formula
  desc "Parsing Expression Grammar Template Library"
  homepage "https://github.com/taocpp/PEGTL"
  url "https://github.com/taocpp/PEGTL/archive/2.0.0.tar.gz"
  sha256 "50d66d715d47a5eadc7e5fd74a229752b42dde5d0c8215e6caa8011837fd1e17"

  bottle :unneeded

  def install
    prefix.install "include"
    rm "src/example/pegtl/CMakeLists.txt"
    (pkgshare/"examples").install (buildpath/"src/example/pegtl").children
  end

  test do
    system ENV.cxx, pkgshare/"examples/hello_world.cpp", "-std=c++11", "-o", "helloworld"
    assert_equal "Good bye, homebrew!\n", shell_output("./helloworld 'Hello, homebrew!'")
  end
end

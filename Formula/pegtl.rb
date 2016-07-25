class Pegtl < Formula
  desc "Parsing Expression Grammar Template Library"
  homepage "https://github.com/ColinH/PEGTL"
  url "https://github.com/ColinH/PEGTL/archive/1.3.1.tar.gz"
  sha256 "34201d56284a449c72798a0536020c6b46684c371a0a886f4c3c586c9372e9bc"

  bottle :unneeded

  def install
    include.install "pegtl.hh", "pegtl"
    pkgshare.install "examples"
  end

  test do
    system ENV.cxx, pkgshare/"examples/hello_world.cc", "-std=c++11", "-stdlib=libc++", "-lc++", "-o", "helloworld"
    assert_equal "Good bye, homebrew!\n", shell_output("./helloworld 'Hello, homebrew!'")
  end
end

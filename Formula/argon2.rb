class Argon2 < Formula
  desc "Password hashing library and CLI utility"
  homepage "https://github.com/P-H-C/phc-winner-argon2"
  url "https://github.com/P-H-C/phc-winner-argon2/archive/20160406.tar.gz"
  sha256 "fbfbea50ebdaddd2b945ee877c8e47b7863c080ee2238603ed6918a84952dc3c"

  bottle do
    cellar :any
    sha256 "5fb0a7803e49c9fa02d4fb687e46e5bc3fd3ba6e6b4fce6a138f8d498e61e510" => :el_capitan
    sha256 "85711883047c0cad702f814db34cf9ace991d54b4143d0727b1e905084ff1f85" => :yosemite
    sha256 "01ae3bd008907a16f990ef922da4d156cc410f60d5fe8b01434ac7b91db70a5f" => :mavericks
  end

  def install
    system "make"
    include.install "include/argon2.h"
    lib.install "libargon2.dylib"
    bin.install "argon2"
  end

  test do
    assert_equal "$argon2i$v=19$m=65536,t=2,p=4$c29tZXNhbHQ$LY26Xe109v98jqoS57OD9ZBwh1CAQavxHyHx1IQ2g/A\n",
      pipe_output("echo -n password | #{bin}/argon2 somesalt -t 2 -m 16 -p 4 | grep Encoded | awk '{print $2}'")
  end
end

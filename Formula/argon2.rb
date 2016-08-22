class Argon2 < Formula
  desc "Password hashing library and CLI utility"
  homepage "https://github.com/P-H-C/phc-winner-argon2"
  url "https://github.com/P-H-C/phc-winner-argon2/archive/20160821.tar.gz"
  sha256 "f81456ae31337a13a1a1b8ffe994d71ace741833a97a75f0c1a76259639bf3b8"
  head "https://github.com/P-H-C/phc-winner-argon2.git"

  bottle do
    cellar :any
    sha256 "5fb0a7803e49c9fa02d4fb687e46e5bc3fd3ba6e6b4fce6a138f8d498e61e510" => :el_capitan
    sha256 "85711883047c0cad702f814db34cf9ace991d54b4143d0727b1e905084ff1f85" => :yosemite
    sha256 "01ae3bd008907a16f990ef922da4d156cc410f60d5fe8b01434ac7b91db70a5f" => :mavericks
  end

  def install
    system "make"
    system "make", "test"
    bin.install "argon2"
    lib.install "libargon2.dylib", "libargon2.a"
    include.install "include/argon2.h"
    man1.install "man/argon2.1"
    doc.install "argon2-specs.pdf"
  end

  test do
    output = pipe_output("#{bin}/argon2 somesalt -t 2 -m 16 -p 4", "password")
    assert_match "c29tZXNhbHQ$IMit9qkFULCMA/ViizL57cnTLOa5DiVM9eMwpAvPw", output
  end
end

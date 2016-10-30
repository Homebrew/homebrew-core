class Argon2 < Formula
  desc "Password hashing library and CLI utility"
  homepage "https://github.com/P-H-C/phc-winner-argon2"
  url "https://github.com/P-H-C/phc-winner-argon2/archive/20161029.tar.gz"
  sha256 "fe0049728b946b58b94cc6db89b34e2d050c62325d16316a534d2bedd78cd5e7"
  head "https://github.com/P-H-C/phc-winner-argon2.git"

  bottle do
    cellar :any
    sha256 "9af790d3daab25c0e0056e34ca9737b4916ccda2074d0fca809b5963fda1e9e3" => :sierra
    sha256 "4980070e3d6a5b6b0232417058e12f03fc55d73ae1d59d6ed19ea9862abc757f" => :el_capitan
    sha256 "a4d1adc7ff93a7bcee2e7f40b270941524a12801b07a2c90fe9f4f7584f9fdf3" => :yosemite
    sha256 "a1c80507bc2f361c5a6384a44d8f9cbfdc506277a681d23c6e75e3bc4a1c6f8b" => :mavericks
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

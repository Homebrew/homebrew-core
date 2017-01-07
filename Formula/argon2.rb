class Argon2 < Formula
  desc "Password hashing library and CLI utility"
  homepage "https://github.com/P-H-C/phc-winner-argon2"
  url "https://github.com/P-H-C/phc-winner-argon2/archive/20161029.tar.gz"
  sha256 "fe0049728b946b58b94cc6db89b34e2d050c62325d16316a534d2bedd78cd5e7"
  head "https://github.com/P-H-C/phc-winner-argon2.git"

  bottle do
    cellar :any
    sha256 "8e260f3bd916421d547c4405f73ec7a8c285d5b8f855208be06706346073ecf8" => :sierra
    sha256 "2dbc464288bf64cf431b33a633ba6977e596af562396925751fc646a6ff4b09f" => :el_capitan
    sha256 "b2d1d802814ab1c1e235119d16efdc095dd90aeb3948d0a306019a2a665dba90" => :yosemite
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

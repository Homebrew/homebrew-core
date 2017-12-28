class Argon2 < Formula
  desc "Password hashing library and CLI utility"
  homepage "https://github.com/P-H-C/phc-winner-argon2"
  url "https://github.com/P-H-C/phc-winner-argon2/archive/20171227.tar.gz"
  sha256 "eaea0172c1f4ee4550d1b6c9ce01aab8d1ab66b4207776aa67991eb5872fdcd8"
  head "https://github.com/P-H-C/phc-winner-argon2.git"

  bottle do
    cellar :any
    sha256 "1951f9c13ad0cf83c8921ad2662f794fe7021c9e34f811e1ebeb0b0b2ffc6d12" => :high_sierra
    sha256 "8e260f3bd916421d547c4405f73ec7a8c285d5b8f855208be06706346073ecf8" => :sierra
    sha256 "2dbc464288bf64cf431b33a633ba6977e596af562396925751fc646a6ff4b09f" => :el_capitan
    sha256 "b2d1d802814ab1c1e235119d16efdc095dd90aeb3948d0a306019a2a665dba90" => :yosemite
  end

  def install
    system "make"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
    doc.install "argon2-specs.pdf"
  end

  test do
    output = pipe_output("#{bin}/argon2 somesalt -t 2 -m 16 -p 4", "password")
    assert_match "c29tZXNhbHQ$IMit9qkFULCMA/ViizL57cnTLOa5DiVM9eMwpAvPw", output
  end
end

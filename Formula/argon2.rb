class Argon2 < Formula
  desc "Password hashing library and CLI utility"
  homepage "https://github.com/P-H-C/phc-winner-argon2"
  url "https://github.com/P-H-C/phc-winner-argon2/archive/20171227.tar.gz"
  sha256 "eaea0172c1f4ee4550d1b6c9ce01aab8d1ab66b4207776aa67991eb5872fdcd8"
  head "https://github.com/P-H-C/phc-winner-argon2.git"

  bottle do
    cellar :any
    sha256 "139741b1c18f60d815ef22066fcfdd3803d688e01cf7f0c004ac5636e811e3ca" => :high_sierra
    sha256 "e48789086ce519c82973ba6b92f28aa2effd558cdf2740ecaf1a10318a3fc40a" => :sierra
    sha256 "cb15f70ccb45ddcfe5b267ab003ffcc07a47a5526b40da3b35135c21a64fb3d2" => :el_capitan
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

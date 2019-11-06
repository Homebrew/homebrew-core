class Argon2 < Formula
  desc "Password hashing library and CLI utility"
  homepage "https://github.com/P-H-C/phc-winner-argon2"
  url "https://github.com/P-H-C/phc-winner-argon2/archive/20190702.tar.gz"
  sha256 "daf972a89577f8772602bf2eb38b6a3dd3d922bf5724d45e7f9589b5e830442c"
  revision 1
  head "https://github.com/P-H-C/phc-winner-argon2.git"

  bottle do
    cellar :any
    sha256 "f8e550c8597728bb9edc5a548497fd7b1219203932cd0f93ecc97a4fbf0bdad8" => :catalina
    sha256 "a76192a41826619fc399e7f6de5e6cb1c8a5fbe6bea4f2c1554daa830fa0e296" => :mojave
    sha256 "830016982e60870f50b3f6fc9a215d8cc4bda6061595f4883f7c11ab19ecba39" => :high_sierra
    sha256 "21889ac6ed40c792f1b372b5aa0d6b3be1be86577a4c1b06b08569124d2d0da2" => :sierra
  end

  def install
    system "make", "PREFIX=#{prefix}", "ARGON2_VERSION=#{version}"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}", "ARGON2_VERSION=#{version}"
    doc.install "argon2-specs.pdf"
  end

  test do
    output = pipe_output("#{bin}/argon2 somesalt -t 2 -m 16 -p 4", "password")
    assert_match "c29tZXNhbHQ$IMit9qkFULCMA/ViizL57cnTLOa5DiVM9eMwpAvPw", output
  end
end

class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/JohnSully/KeyDB/archive/v6.0.16.tar.gz"
  sha256 "809369321d1a98a57337447cce0fd84197dd3c9b493ec1ea2e29268d8534ee5d"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "af7c50a7f480f837135ee2a174fbbfddc70049fc185e5cca67978ad295ada657" => :big_sur
    sha256 "399a17386d452bac3d05d7997af196954b4dddb4dd3c2dd753e112405c8eefe6" => :catalina
    sha256 "19e86e52f647fb1557683cd6f4b682a5e150095f0f99e13c19b7816c81d3bd17" => :mojave
    sha256 "ab28323dbffb9fcc0f11eeb18d9490808592b5caab0f8168e310937abb83b212" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/keydb-server --test-memory 2")
    assert_match "Your memory passed this test", output
  end
end

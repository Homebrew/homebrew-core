class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/JohnSully/KeyDB/archive/v6.2.0.tar.gz"
  sha256 "61a2996c8d56e564930119b115674032d8a1de2b50d67a9c555be6e7975ed567"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "af7c50a7f480f837135ee2a174fbbfddc70049fc185e5cca67978ad295ada657"
    sha256 cellar: :any_skip_relocation, catalina:     "399a17386d452bac3d05d7997af196954b4dddb4dd3c2dd753e112405c8eefe6"
    sha256 cellar: :any_skip_relocation, mojave:       "19e86e52f647fb1557683cd6f4b682a5e150095f0f99e13c19b7816c81d3bd17"
    sha256 cellar: :any_skip_relocation, high_sierra:  "ab28323dbffb9fcc0f11eeb18d9490808592b5caab0f8168e310937abb83b212"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6893ae34d2b94bfdcb5e6bcfe59a600bde42160f37a8dbcde8b34e91b107e3cc"
  end

  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/keydb-server --test-memory 2")
    assert_match "Your memory passed this test", output
  end
end

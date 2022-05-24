class Clog < Formula
  desc "Colorized pattern-matching log tail utility"
  homepage "https://taskwarrior.org/docs/clog/"
  url "https://gothenburgbitfactory.org/download/clog-1.3.0.tar.gz"
  sha256 "fed44a8d398790ab0cf426c1b006e7246e20f3fcd56c0ec4132d24b05d5d2018"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/clog.git", branch: "1.4.0"

  livecheck do
    url "https://gothenburgbitfactory.org"
    regex(/href=.*?clog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "503a96204475c67ba2d564cc98b0964bbff48da89e4c2b3f0d4125a7fb32ffc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce662c5bd6dfdc6dca64911cbdc37ebcfe5aac7eaea48215f94d3b94bba0b37c"
    sha256 cellar: :any_skip_relocation, monterey:       "71bcca7b6cb4bf84c6c0c678d45b593f551e9b351bcb0fd557e7e7c0b90648c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "864d26fdc6960a6b4daf9ca76ef52e5e2db4a8ece187dbc7d8b87939e4823d32"
    sha256 cellar: :any_skip_relocation, catalina:       "0a5985eee7c41d2199e64105cb0d32b8e065b57257841f48b2eb36a3a662bc7b"
    sha256 cellar: :any_skip_relocation, mojave:         "ec11a01ddd6a6ad70a655c74f569af9a6b56cf66f87ea448e296a1e208449ba4"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b5309f9e692f111a0b68599ff465da02783d2f28a4b10d958c19e616177eb37a"
    sha256 cellar: :any_skip_relocation, sierra:         "97e07b94ea058c766f4d036cc503fc6ec08ca64cddced33d63723e4611534595"
    sha256 cellar: :any_skip_relocation, el_capitan:     "8f42168b8e165c4c1f1265b410ef62087b370075cc27269f1908eb0f373645c5"
    sha256 cellar: :any_skip_relocation, yosemite:       "a6c42c7d0795252434a3e1fc0307fc40490a4f29a9186408fa3ed7d82ba5f02e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74b571a8740f2d0d8798ed8ee046d9239404ec6789987b98eb48b25c122c00e3"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      Next step is to create a .clogrc file in your home directory. See 'man clog'
      for details and a sample file.
    EOS
  end

  test do
    # Create a rule to suppress any line containing the word 'ignore'
    (testpath/".clogrc").write "default rule /ignore/       --> suppress"

    # Test to ensure that a line that does not match the above rule is not suppressed
    assert_equal "do not suppress", pipe_output("#{bin}/clog --file #{testpath}/.clogrc", "do not suppress").chomp

    # Test to ensure that a line that matches the above rule is suppressed
    assert_equal "", pipe_output("#{bin}/clog --file #{testpath}/.clogrc", "ignore this line").chomp
  end
end

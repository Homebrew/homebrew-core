class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.3.13.tar.gz"
  sha256 "dc14c28bfbe0beef5ec93b4614a00bd419d5a793c8a678ba3b5544bd1dd580b6"
  revision 1
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "cbfdbf9fcf3aa85a9609c75e27dc492edd669f8e7279af1cab1ab4c9a9860d42" => :mojave
    sha256 "34ee3afc700759851c95bb9369c4df0f267e5d070266aa3021012c03af11b6ee" => :high_sierra
    sha256 "00b4985c6da2a4f4167544ed0ee902d27ab7517a008d8467faf403224dc21929" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "python"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/bear", "true"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end

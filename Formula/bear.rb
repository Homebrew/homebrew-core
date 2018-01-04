class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.3.11.tar.gz"
  sha256 "4616237fd63066603793dca3fbf3f2c39e8c75bbe9967bdda103a56f31071cd4"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "9e96a591af0e0e0bf1b89c9cf2c275993e9334f30dade73aab035e09babb2ff7" => :high_sierra
    sha256 "e7a4e21095572df49c2f3a080efe0b1868dc04a01a2dbd01f69ea2f25e2e5adc" => :sierra
    sha256 "69f3a874a296faace27f83995c9f73e53afe837626ab1afdf6efc4e60940b639" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/bear", "true"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end

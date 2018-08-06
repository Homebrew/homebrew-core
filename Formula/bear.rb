class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.3.12.tar.gz"
  sha256 "25ef998b94138f586cd627c7cb6187259cd9623f3e9f6695623e91f2aec80c86"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "dc87210799ab3fc9c541d14799a2a93e20eefc81d39b806c7fd9c74acf5504a7" => :high_sierra
    sha256 "1faf6aa93e8963252e04d0658f6329a0738cd5891ebd47c98224f0fc1f3e0c0c" => :sierra
    sha256 "771bdec380ed39cfcbe5cacc0ef05e3536702424c22ad30917fa9a8ef325e414" => :el_capitan
  end

  depends_on "python@2"
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

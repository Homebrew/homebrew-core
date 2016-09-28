class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.2.0.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/b/bear/bear_2.2.0.orig.tar.gz"
  sha256 "6bd61a6d64a24a61eab17e7f2950e688820c72635e1cf7ea8ea7bf9482f3b612"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "8469bf0b4ae18208304134787c9ff6938b191f1f4ecf5e88c516c228ad0eeff2" => :sierra
    sha256 "316e61b4a0198e4627e18491e52422df67d7fb23cd72ad01b6d8b2e7d6682e34" => :el_capitan
    sha256 "5e71d4bfae579a1eac79692f0558d2541d1d9b46ad8bafdbaa303ef94f716509" => :yosemite
    sha256 "570c03e31526cfbfc2b7d120858cffeb5f04f00a8d96730aa79732714b0c92f4" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/bear", "true"
    assert File.exist? "compile_commands.json"
  end
end

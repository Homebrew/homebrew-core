class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  head "https://github.com/doxygen/doxygen.git"

  stable do
    url "http://doxygen.nl/files/doxygen-1.8.15.src.tar.gz"
    mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.15/doxygen-1.8.15.src.tar.gz"
    sha256 "bd9c0ec462b6a9b5b41ede97bede5458e0d7bb40d4cfa27f6f622eb33c59245d"

    # Fix build breakage for 1.8.15 and CMake 3.13
    # https://github.com/Homebrew/homebrew-core/issues/35815
    patch do
      url "https://github.com/doxygen/doxygen/commit/889eab308b564c4deba4ef58a3f134a309e3e9d1.diff?full_index=1"
      sha256 "ba4f9251e2057aa4da3ae025f8c5f97ea11bf26065a3f0e3b313b9acdad0b938"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "e3144ca8ebdb1abd668cb4eee36feb3bb5d545bc3d056f207109d2ae57013f5c" => :mojave
    sha256 "b6b7234f2644de37a48d7459f3b360127c4e92df8bb56d48b9a4128f58eaf90b" => :high_sierra
    sha256 "305156f3d060deeee197759c5ce6ea8a1da36ad52f8104b42cd7ccbb2b20c0e7" => :sierra
  end

  depends_on "bison" => :build if build.head?
  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=#{MacOS.version}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
    end
    bin.install Dir["build/bin/*"]
    man1.install Dir["doc/*.1"]
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end

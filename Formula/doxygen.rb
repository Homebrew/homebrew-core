class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  url "http://doxygen.nl/files/doxygen-1.8.16.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.16/doxygen-1.8.16.src.tar.gz"
  sha256 "ff981fb6f5db4af9deb1dd0c0d9325e0f9ba807d17bd5750636595cf16da3c82"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "e3144ca8ebdb1abd668cb4eee36feb3bb5d545bc3d056f207109d2ae57013f5c" => :mojave
    sha256 "b6b7234f2644de37a48d7459f3b360127c4e92df8bb56d48b9a4128f58eaf90b" => :high_sierra
    sha256 "305156f3d060deeee197759c5ce6ea8a1da36ad52f8104b42cd7ccbb2b20c0e7" => :sierra
  end

  depends_on "bison" => :build
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

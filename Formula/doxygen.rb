class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  url "http://doxygen.nl/files/doxygen-1.8.15.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.15/doxygen-1.8.15.src.tar.gz"
  sha256 "bd9c0ec462b6a9b5b41ede97bede5458e0d7bb40d4cfa27f6f622eb33c59245d"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e5d8d60c9304b0146866fbe1edc0096d54fbd979fadf2fb8eed352548a3875f4" => :mojave
    sha256 "eee7e8c42fff656c3b335f5f8393a9ce7113eff535eff05e8f876ae7b40d083c" => :high_sierra
    sha256 "a086e334ee3b24456e87a2806cadc35e42d1dcb10ee94c5a1c091b4f5c9d434c" => :sierra
  end

  depends_on "cmake" => :build

  # Fix build breakage for 1.8.15 and CMake 3.13
  # https://github.com/Homebrew/homebrew-core/issues/35815
  patch do
    url "https://github.com/doxygen/doxygen/commit/889eab308b564c4deba4ef58a3f134a309e3e9d1.diff?full_index=1"
    sha256 "ba4f9251e2057aa4da3ae025f8c5f97ea11bf26065a3f0e3b313b9acdad0b938"
  end

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

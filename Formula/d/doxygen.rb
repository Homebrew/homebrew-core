class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.15.0.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.15.0/doxygen-1.15.0.src.tar.gz"
  sha256 "a8cafe605867ad475aaf288a3852783076e1df83aabf16488bbfa958062e7440"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42405feb56da268767c920d2abf25ddfe0f24d3c4c0a4128f5403298f760ff7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c0af6e75eb3574bb8a4b56cf44e43a44d92399188e611e86307edb7ac28fea8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebdf6db27eca4f28351f3048bd22148fe161459af097d13e594672ae4d112add"
    sha256 cellar: :any_skip_relocation, sonoma:        "e90217d7fb072089ed49a420872b0845914df54d7f2d8227df56620b489d16cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2edc41f859b4fbc634e5e08cbaa00701adc3242c4e5516f8d50843c8078d35b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f36442ab1eea967aa66a5b5db5b59cffb87c75eb5ec81e43c43fe3227e64cde8"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build, since: :big_sur
  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which("python3")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build", "-Dbuild_doc=1", *std_cmake_args
    man1.install buildpath.glob("build/man/*.1")
  end

  test do
    system bin/"doxygen", "-g"
    system bin/"doxygen", "Doxyfile"
  end
end

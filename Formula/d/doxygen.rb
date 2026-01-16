class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.16.1.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.16.1/doxygen-1.16.1.src.tar.gz"
  sha256 "201ce33b514ea87cc1697c0dcf829692c2695c1812683a9cc622194b05e263a8"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1f4cf02f9ce45b0b994819f4e38a1aa243a28dddfec953fef8679d47064e2e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ae1834cdf58645b3c5fab847b4f03de8cd94d74725fdab3a08c199f8fb2012d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d9ce6c6aecc2f0b6a048453fa78dc66bdedb6f37fe76c4a3e136fbe37668371"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fb471112843de03b9dfe61c0f1612dd6d5deb69f28b273d0f0b1e08aec25447"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb514ebc6d4e2b9aead5758c4d1d907bbaf74861ea40d3a9b4ced03afd64b289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d66ed3672e6af0d95a9a29585dab4bd7ed73a9397627038dd5d4a7cb8a5efc46"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build, since: :big_sur
  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPython_EXECUTABLE=#{which("python3")}",
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

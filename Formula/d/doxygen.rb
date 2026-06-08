class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.17.0.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.17.0/doxygen-1.17.0.src.tar.gz"
  sha256 "fa4c3dd78785abc11ccc992bc9c01e7a8c3120fe14b8a8dfd7cefa7014530814"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e10e1a237c33f3aec3117f565c6a57edfc2267add2dfbeeb71bdb12edcdfc7dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ef2bf9c4dcde66dddaac5fc04d52c83e4817f66d497c3de444e23991633145d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8978bef041590908436d0ac06f44552f4d69555071c1079a98c67d0a71f7ba7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c92988ecdcac370c67bb4c8e95deffb5b954344385db6f66226542973a6f942"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ae11fe672b4e5d6fc8f77ae846e95da2e957c537f22d57efe93c3c9eeba9c60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37c3265613b0d5334666077a3fb8264bede87da235cdc6abfd223243fd714205"
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

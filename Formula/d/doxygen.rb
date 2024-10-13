class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.12.0.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.12.0/doxygen-1.12.0.src.tar.gz"
  sha256 "a3a3dba2018ef409d83d81a2fc42a0d19bdbe087252ef342bf214b51b8b01634"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "358a28534368ec74031160dc4a91f66400740594c6f81ae1ccfd720fc77b26e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "056c2729260fb3189ec107c5e1186f7634f4fea1bc28f69a14467dc1af549c38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cff27865073a17e2264711120fd13561c26773a6db4cff17336b8930980e1c27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63c7b68e43b7f03a7c9c5f95aca5244baf5794b590762004518659e54c1d9a1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c051c47ee4982ad11f2c23a7aa8fbb664874d799685852f350ef08eaf2c7bb2a"
    sha256 cellar: :any_skip_relocation, ventura:        "dd2dfbfacff168cf29f003af6b29fa1b51ca8bad4a5630e8224098695fb82b78"
    sha256 cellar: :any_skip_relocation, monterey:       "51940f39a1836b55266901fa4ae03eb941cc3ffff635cb0da0a041d1c9e746fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42e0f9dbdaaa5bfdf811cc4e349773ae6f712a5bb5be0887d436fa21775bea86"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build, since: :big_sur
  uses_from_macos "python" => :build

  fails_with :gcc do
    version "6"
    cause "Need gcc>=7.2. See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66297"
  end

  fails_with :clang do
    build 1000
    cause <<-EOS
      doxygen-1.11.0/src/datetime.cpp:100:19: error: no viable constructor or deduction guide for deduction of template arguments of 'array'
      static std::array g_specFormats
                        ^
    EOS
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which("python3") || which("python")}",
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

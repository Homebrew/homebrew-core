class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.10.0.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.10.0/doxygen-1.10.0.src.tar.gz"
  sha256 "dd7c556b4d96ca5e682534bc1f1a78a5cfabce0c425b14c1b8549802686a4442"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30e345a5411f69cefd00cf43dc48caa61b2c450e6b560a54cead779f90d43a70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c80d2021fe3b0e26302f178e2c39cd746eefbadfcb31626c2c6162bdaaba5e3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a34ab8936f378712e1fea29a778681e0d6f1c3430a40092064cdad1ec95c464"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f1d70f0044c25bb6533c5dbb5120eb501f69d2bb745e00b5311a47998f7556b"
    sha256 cellar: :any_skip_relocation, ventura:        "29d8f4858a59880c19140be509777c264477ffb7f36e9f64a09b63c8f1e277c7"
    sha256 cellar: :any_skip_relocation, monterey:       "3a3fda383bf8ee67804b8b8e95dfcf9c047d5eb72255707cd1b1626cb7d359ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cec73411c38e0845135ab5a2e9f52c01dd40b5831a7ac4444aab3a15fea82b0"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build, since: :big_sur
  uses_from_macos "python" => :build

  fails_with :gcc do
    version "6"
    cause "Need gcc>=7.2. See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66297"
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

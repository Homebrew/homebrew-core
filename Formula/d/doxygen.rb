class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.11.0.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.11.0/doxygen-1.11.0.src.tar.gz"
  sha256 "c9edfdf8c5f3e8bee0c4c967850caead27099883ee7ff8b11044e6d63faf3607"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3563bf8fb8ef84bf1bb3fbcf70cc91b35a1d6bccecc97ebeb9f6de8ce8266f74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62d0f4cdb2e1b99efde1ca2437b19b2532784fc50becc1ed8464544f7cad162a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20d0a7d6c962e71bd1191d422573621aa3f5b90f5323744e4a20d4e155b873fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2095539b2bc24893b171c477967e473ae7940cc7c30fb60a15bbb5d8c790b96"
    sha256 cellar: :any_skip_relocation, ventura:        "8d4065e87a6a7e45a1f08f3da7fbdbb228f6377125907ac249f58c9ae78a6b1e"
    sha256 cellar: :any_skip_relocation, monterey:       "03d4746629c4f60bafc6b09a4975cee0a70806cfd35bc39132c2e740e4528d2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfb35d6329584d7ff43e14d2d071b37d099dbc773e513f4a5f1a6df73081d72f"
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

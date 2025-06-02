class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "aeeefe3a9b44761b2cf110017d2b1dfa2ceeb873da96d283ba5157380c5d0ce5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "064f58d291191e9d7264db2992ee79213b3b88927fb953d3cb70dc09eb458d6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59d88950f340427381e84fd644fbc6672a1255812f6c1bc4bb82aaed76640190"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1432fd9d7d702c1c27f0cf574b337e4191ee454ba439ad0e71be1fecb82f707"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b080ed40975a908e12c9c94829f2b7664382f9fbd5b6083cfe7a289d5841e792"
    sha256 cellar: :any_skip_relocation, sonoma:         "7499dc7a7e179e486b641d68d31ee0b7c6f9a16949f58da91e4702ddb970eb32"
    sha256 cellar: :any_skip_relocation, ventura:        "80dd7d731c9bc516931aa77f313eb9a2016e9f0e50adec2e5e8966c0c860584b"
    sha256 cellar: :any_skip_relocation, monterey:       "3d74d9a45e232e70927cdc16f9bb90b839efb979297bf887da998c8b1b479747"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "79baa56d60ecd2123a9155db2aa02d49b4e290e4a5c87d084f3643ebd699ac4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f85bc09b930b41d316d408e81c26f99f275a578bad4eeb3a24aa8796ca19835d"
  end

  depends_on "cmake" => :build

  def install
    # Disable opportunistic linking against Cairo
    inreplace "CMakeLists.txt", "find_package (Cairo)", ""

    args = %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <frei0r.h>

      int main()
      {
        int mver = FREI0R_MAJOR_VERSION;
        if (mver != 0) {
          return 0;
        } else {
          return 1;
        }
      }
    C
    system ENV.cc, "-L#{lib}", "test.c", "-o", "test"
    system "./test"
  end
end

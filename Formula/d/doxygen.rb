class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.nl/"
  url "https://doxygen.nl/files/doxygen-1.18.0.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.18.0/doxygen-1.18.0.src.tar.gz"
  sha256 "a1deed70a6785bbec95a2b2a9e419dc7f7b223a9d74a8644ae611c8e2dcdd354"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "554075817e7d357ddb233496a332a6d8d7c9414e7fe21e514c40507fe7428a93"
    sha256 cellar: :any, arm64_sequoia: "2334f389368fdc1055a87d69bd3c25b7eb8be4936d30bff13fded74c6262f5ce"
    sha256 cellar: :any, arm64_sonoma:  "71a03795e6e710354915c27f25c69a5be73dd63d98ad3734546dd58be84fe0b6"
    sha256 cellar: :any, sonoma:        "41f4b0f571e7e28b465d941883758806c2b593065fea28f622a0743c3d347737"
    sha256 cellar: :any, arm64_linux:   "019cac1efd6b25ee86a02ce47e42181593f8a252caa6afbee05336c226a1fe23"
    sha256 cellar: :any, x86_64_linux:  "54c060859ce305bf6feb217ae367eeb82a607de0bf9a901f13f71feccb5a49e0"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "spdlog"

  uses_from_macos "flex" => :build, since: :big_sur
  uses_from_macos "python" => :build
  uses_from_macos "sqlite"

  def install
    # Remove bundled dependencies
    rm_r(%w[
      deps/fmt
      deps/spdlog
      deps/sqlite3
    ])

    args = %W[
      -DPython_EXECUTABLE=#{which("python3")}
      -Duse_sys_fmt=ON
      -Duse_sys_spdlog=ON
      -Duse_sys_sqlite3=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"doxygen", "-g"
    system bin/"doxygen", "Doxyfile"
  end
end

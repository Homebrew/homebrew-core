class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.15.0/poco-1.15.0-all.tar.bz2"
  sha256 "4b0f7bbbb1abbd1c06e000635b20530b5a977f702cfd54647926c996d99a1282"
  license "BSL-1.0"
  compatibility_version 1
  head "https://github.com/pocoproject/poco.git", branch: "main"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+\w*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2ea32a69fbaa18c2e1285164eb60a7434512fc9e8f9391a8ba6e0ae5fae4c81e"
    sha256 cellar: :any,                 arm64_sequoia: "cb8229016187d81720ac352b9629d5fb004dd9b8c9b67df4c1cf01a4dfc75985"
    sha256 cellar: :any,                 arm64_sonoma:  "f2eb97e7ebf59438650a30a6baad07978cff8470869cee0cbf073621c1adb8db"
    sha256 cellar: :any,                 sonoma:        "8761f92bdfa0bb6829f7c872ee5331cb39bc6d66a96847d1aafab87f80a63391"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "933757a5315034c5c2763983dd2e641d022ce5eb25ce68d4b3c92f881ed40fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03547c258e6fd4ea6d6f597d485439bbe5f172c8cee01d054f091b505fe9f4c1"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "utf8proc"

  uses_from_macos "expat"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -DENABLE_DATA_MYSQL=OFF
      -DENABLE_DATA_ODBC=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPOCO_UNBUNDLED=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"cpspc", "-h"
  end
end

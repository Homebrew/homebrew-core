class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.15.3/poco-1.15.3-all.tar.bz2"
  sha256 "562a1ba1a6db4665f81091c35e997b73f87e1b45e2ab2854cd720d2349518abc"
  license "BSL-1.0"
  compatibility_version 4
  head "https://github.com/pocoproject/poco.git", branch: "main"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+\w*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c81421dc2f3992003c3661a37ab2c1575b59e726fedf787bbf0814cc69eb5a8"
    sha256 cellar: :any,                 arm64_sequoia: "58342ece9f3454e5c80bf55aa1a64cf2e4c3c5fd2f6609d3aca0f365906d4911"
    sha256 cellar: :any,                 arm64_sonoma:  "2bf92a0f689198ad630246df6366c2c47dc2770bd086d332d2e034fdd110c300"
    sha256 cellar: :any,                 sonoma:        "30d1007827e66319d6519b8aaa8b37130c8428e934df71886bcbfd4e112b2f08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2803c48feb6871678ffe83f9238d703b325160bf5e1e886c17a4f5041fe8e03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e88bc5b6b7d9d0b1f4d242353261e3ae01f9493afa8f7de58cc0bbaf2b0095b3"
  end

  depends_on "cmake" => :build
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

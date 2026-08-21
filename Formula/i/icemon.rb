class Icemon < Formula
  desc "Icecream GUI Monitor"
  homepage "https://kfunk.org/tag/icemon/"
  url "https://github.com/icecc/icemon/archive/refs/tags/v3.4.tar.gz"
  sha256 "75f79aa21e0524e384c9041b558d3b55ad5e2ce9a8c851d6c7ca94ce0bfe7e9a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dbc83718e9cf1dcd6031020258c3b7cecb6a38ff927f7109d0a4a8d7ecb12f63"
    sha256 cellar: :any, arm64_sequoia: "13f706714d74294a8daabbde4f80b7ab9330b8bda59df22eaf46b457d305f47c"
    sha256 cellar: :any, arm64_sonoma:  "a87f4da909e0cbcccf5fca219551e1d6a10df55f79204437900986400a2ec510"
    sha256 cellar: :any, sonoma:        "b5af44cd4aa902669241c8d33b4170648f042b2fb61311e6674ea9ecf715ee3d"
    sha256 cellar: :any, arm64_linux:   "c2ef677904a70ce81c68f0e171349e1946d680a60d34ef505304fa722747b259"
    sha256 cellar: :any, x86_64_linux:  "b5d9dd76cd9972ed62fbb7bd0f83ba4d2f457229d1627de1ffc251962f06ac08"
  end

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build

  depends_on "icecream"
  depends_on "lzo"
  depends_on "qtbase"
  depends_on "zstd"

  on_macos do
    depends_on "libarchive"
  end

  on_linux do
    depends_on "libcap-ng"
  end

  def install
    args = ["-DECM_DIR=#{Formula["extra-cmake-modules"].opt_share}/ECM/cmake"]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    if OS.mac?
      system bin/"icemon", "--version"
    else
      output = shell_output("#{bin}/icemon --version 2>&1", 134)
      assert_match "qt.qpa.xcb: could not connect to display", output
    end
  end
end

class Clucene < Formula
  desc "C++ port of Lucene: high-performance, full-featured text search engine"
  homepage "https://clucene.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/clucene/clucene-core-unstable/2.3/clucene-core-2.3.3.4.tar.gz"
  sha256 "ddfdc433dd8ad31b5c5819cc4404a8d2127472a3b720d3e744e8c51d79732eab"
  license any_of: ["Apache-2.0", "LGPL-2.1-only"]
  head "https://git.code.sf.net/p/clucene/code.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "a72d28c7e47cae2af5817ed8f2765308aa0b4eac7eafb7fa46451cd8cb6eb039"
    sha256 cellar: :any,                 arm64_sonoma:   "3923df21bb6184b548889e7d9ed0204048007bbe4fc537d57711a25db4d22558"
    sha256 cellar: :any,                 arm64_ventura:  "ecbe0c9275432a532b57742e33a764144a27b26be4801db7d2c6b024f15eff75"
    sha256 cellar: :any,                 arm64_monterey: "cbbe283763a33bd7c68aa833fef9209403f4de79cb991772dca74bb6e99b60dd"
    sha256 cellar: :any,                 sonoma:         "2ea84f1cd35e34945fa6334d250ce6cd89f111f37e3986e78bbbd058b586ee87"
    sha256 cellar: :any,                 ventura:        "e0ca763506918ccefd484e57ed1c3633ed58cf5948973fb69102b7a2a537bf4f"
    sha256 cellar: :any,                 monterey:       "80cc75e161baf8ec7e7c37c7a1b835e86e2190a8a9209ae449318096cada552a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a142b08aa18a0d5ddd94a39ba005c40fba111cd0bf0cef1cb4ace20ad3b4cea"
  end

  disable! date: "2024-12-16", because: :unmaintained

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  # Portability fixes for 10.9+
  # Upstream ticket: https://sourceforge.net/p/clucene/bugs/219/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/clucene/patch-src-shared-CLucene-LuceneThreads.h.diff"
    sha256 "42cb23fa6bd66ca8ea1d83a57a650f71e0ad3d827f5d74837b70f7f72b03b490"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/clucene/patch-src-shared-CLucene-config-repl_tchar.h.diff"
    sha256 "b7dc735f431df409aac63dcfda9737726999eed4fdae494e9cbc1d3309e196ad"
  end

  def install
    # Work around build failure on ARM macOS
    inreplace "src/shared/CMakeLists.txt", ";fstat64;", ";" if OS.mac? && Hardware::CPU.arm?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
end

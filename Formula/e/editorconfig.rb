class Editorconfig < Formula
  desc "Maintain consistent coding style between multiple editors"
  homepage "https://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-core-c/archive/refs/tags/v0.12.9.tar.gz"
  sha256 "4aaa4e3883332aac7ec19c169dcf128f5f0f963f61d09beb299eb2bce5944e2c"
  license "BSD-2-Clause"
  head "https://github.com/editorconfig/editorconfig-core-c.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6ce5b3c6be160eb7ef11cc41b3dd60231e8100c970a5d7888984c8003e426977"
    sha256 cellar: :any,                 arm64_sonoma:   "68292eee4ca5bb261e091e5546caf2d6e6ecdf78e5d6bfd359bc66cfb4676230"
    sha256 cellar: :any,                 arm64_ventura:  "758d3759492e33359ab231574bb223c5fed86b3b207139701ba5798963c09836"
    sha256 cellar: :any,                 arm64_monterey: "f65e5c1e7edef043e3042347662ed957cc2cadbbab09b8de64f1e57d6727e4bf"
    sha256 cellar: :any,                 sonoma:         "ac46d5659ab9aaafd7552a796ce848b72c6872fb26d1542f84ea87370e8b0b86"
    sha256 cellar: :any,                 ventura:        "ed9992d208d2eceeabcd646ad6c5a2d8d5ac36e8da10dd61ee4080cf97cc4148"
    sha256 cellar: :any,                 monterey:       "20c4080381d9f63379cdaf63e5b827f03698334ed2c3d65ae7cbe936124a713f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "da0b49ae920c2a24b6614374194e1e05a2e44408fe2cd6d5cd62cef9c9255e4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edae75cc4622ec47783d0c1293c84f0f3eb4d2f1d1c4f0e837f636a1810c18c0"
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"editorconfig", "--version"
  end
end

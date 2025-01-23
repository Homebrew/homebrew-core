class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_8_8/davix-0.8.8.tar.gz"
  sha256 "7ff139babf39030dd9984ad5ff8cd5da1ced2963f53f04efc387101840ff3458"
  license "LGPL-2.1-or-later"
  head "https://github.com/cern-fts/davix.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9c20406f04d9aa93eb65ea95ea0c093e2c74c042eab6452ffe887ec10f634367"
    sha256 cellar: :any,                 arm64_sonoma:  "b1ab99aeec645d8aad1ca6c5796a83d737fb434854372ff81bd123e5be7c551c"
    sha256 cellar: :any,                 arm64_ventura: "7245869754071c3e8e1eab9f2297c566f3f7c09323a3a389d867f30ddaab0e1a"
    sha256 cellar: :any,                 sonoma:        "7e957e1bce4aa4c65e178929fc3c3949eee4fa669ec3ba4b9b34975df1c0b5dd"
    sha256 cellar: :any,                 ventura:       "e3e271e1fe83c01de2b5de177a27b26e8be326ae38a6a5db6bc2a177afb74980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "478040f1e1bea1d2b68ca3e69963d22831171cc1cc36fb61624be6b808147102"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "curl", since: :monterey # needs CURLE_AUTH_ERROR, available since curl 7.66.0
  uses_from_macos "libxml2"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = std_cmake_args + %W[
      -DEMBEDDED_LIBCURL=FALSE
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLIB_SUFFIX=
      -DBENCH_TESTS=FALSE
      -DDAVIX_TESTS=FALSE
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"davix-get", "https://brew.sh"
  end
end

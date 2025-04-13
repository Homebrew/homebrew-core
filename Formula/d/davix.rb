class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_8_10/davix-0.8.10.tar.gz"
  sha256 "66aa9adadee6ff2bae14caba731597ba7a7cd158763d9d80a9cfe395afc17403"
  license "LGPL-2.1-or-later"
  head "https://github.com/cern-fts/davix.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "da21e84d94a79ee04801da53369791a3150a7b2d258f0157b2d93340d24652d6"
    sha256 cellar: :any,                 arm64_sonoma:  "05c4246253f683448f3ede09b02520e196a33b4e69a312cbdc9f10b526adbfa2"
    sha256 cellar: :any,                 arm64_ventura: "32f192b3827668aff416b3ab09450becae5e481f2fb40594b91b863b2da567d6"
    sha256 cellar: :any,                 sonoma:        "f83caf6a8ef4a3b2a82e5d45eeedbc3ff89a8e2c9d7abfed2995424974d386ab"
    sha256 cellar: :any,                 ventura:       "5e2607d54a8b793c3d657acd19018c224cca7fc327e25b2ea938019694d41c40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57869e453d9e1b81e021f7fc6f1d0584edafd15ebe40721857b86c1fad964eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e988353573b61da496468299b761a23199d418796f39d1a19e0c37b870be6883"
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

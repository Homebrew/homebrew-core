class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/doc/trunk/README.md"
  url "https://objfw.nil.im/downloads/objfw-0.90.2.tar.gz"
  sha256 "4de24703d45638093a5196eba278a05b3643e8be0ae2eece5c81ba3e2c20bdbb"
  license any_of: ["QPL-1.0", "GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0fd7eba37d5517c35a6088c4320513fbe96de81f592a19a7f2d54ff617317b22"
    sha256 arm64_monterey: "83b505efb37df36fe0dba40337409835856293328b2977f28d0ef8868e1d250e"
    sha256 arm64_big_sur:  "59dd4798a6017b6062614f70004c87feb3bbf7aecb9ac2165b5b6f92353c6361"
    sha256 ventura:        "e1acd1fa4297e992242864af7d3406bb7ef7b66e1035fbcf3ba66f1bc031f8e8"
    sha256 monterey:       "af63eb9a8b2ba6a183ef1bafc61cc7a527ee1d4088e073095d625051f7ca4c79"
    sha256 big_sur:        "d0ef5bb1b837ab3ebebc3737361bd65f739d9592f8e0b139a7786a19df8108c9"
    sha256 catalina:       "07ede29c16dec01d6eb8dd2dca6f79ec993f99298b38a78276f6257ebfb71c6a"
    sha256 mojave:         "abc09195b6abf66d1d638af2999abe712a41cdcbb4bbf8d7ea422443150ae637"
    sha256 high_sierra:    "33c72d86bb5a56ff4a2c9607707edb31f7af21bf863c8d34d95f6c527d9ee483"
    sha256 sierra:         "2369c4233bafe95aeea87f678cc5e0f0b001d36b5aeff6a7b6512f766d77eb5e"
    sha256 x86_64_linux:   "57dcb7565015413f1fb668f18b03af564e8b631b47e051c6b98dfb57d1530fa0"
  end

  head do
    url "https://github.com/ObjFW/ObjFW.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  on_linux do
    depends_on "llvm"
  end

  fails_with :gcc

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    inreplace bin/"objfw-config", "llvm_clang", "clang" if OS.linux?
  end

  test do
    system "#{bin}/objfw-new", "app", "Test"
    system "#{bin}/objfw-compile", "-o", "t", "Test.m"
    system "./t"
  end
end

class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "https://librsync.github.io/"
  url "https://github.com/librsync/librsync/archive/v2.3.4.tar.gz"
  sha256 "a0dedf9fff66d8e29e7c25d23c1f42beda2089fb4eac1b36e6acd8a29edfbd1f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d89603add652e75d67066aa9477b3d0ec7c1506386f9f39b16a4dae526ddfc3f"
    sha256 cellar: :any,                 arm64_monterey: "461c371c845a9d9e11f87d42b2728b86add7dda8f6a2dd8fac92863b072a6cfb"
    sha256 cellar: :any,                 arm64_big_sur:  "186a5d37529edc819f7a252f8963711172ed728e8eb53cef7057b4af35f50284"
    sha256 cellar: :any,                 ventura:        "8da189cee0efb319169720c595b1155d28b411207c4aede49f183883b9244b74"
    sha256 cellar: :any,                 monterey:       "15175944a49b2d7144a0699770a3a7417321935f5e1b59a5bdd88bfc62d586ed"
    sha256 cellar: :any,                 big_sur:        "5f6642fc425a2c00562044691956722c994aeeb1bcf8ed9f8624c8de4a54b0fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6d3f9187ead6288ea4ab0d9519466f02cb3ef81c5d90624a93960bf7c207c49"
  end

  depends_on "cmake" => :build
  depends_on "popt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    man1.install "doc/rdiff.1"
    man3.install "doc/librsync.3"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rdiff -V")
  end
end

class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.13.0.tar.gz"
  sha256 "cb2a393c9c1fae7aba76b950bb0ad393ba105409fe1a147ccd61b0aaa1501066"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libvpx.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "868daf3511cf9fb086551f407caa54103c93e149dc31d4462a8b866370dc8682"
    sha256 cellar: :any,                 arm64_monterey: "cb9f419c82b0cef5ca968e0ba106898d4649d652f44d3fc8e7e9a2d62aa88134"
    sha256 cellar: :any,                 arm64_big_sur:  "16d6cb5c255eb5cfe8d2b6959f9adabb8f42b80787fdb1bdb2f75d6c6843e849"
    sha256 cellar: :any,                 ventura:        "695248793be7b9764a1673cb69921b5d7e2f2200fe1f338d35286f82418762fb"
    sha256 cellar: :any,                 monterey:       "ee12fabeb869d1c7d42581b65aaafc10b535a8e598841fe07456ced8c0b52062"
    sha256 cellar: :any,                 big_sur:        "3f5b56aeac322d74c7b21434d8e287e868511c1cb2a2aefd3b05ca17daa5c14b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8cf342f3173238c05c54294914cac333f939ca0329edb2ecca44c5ef7f05fd8"
  end

  on_intel do
    depends_on "yasm" => :build
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-examples
      --disable-unit-tests
      --enable-pic
      --enable-shared
      --enable-vp9-highbitdepth
    ]

    if Hardware::CPU.intel?
      ENV.runtime_cpu_detection
      args << "--enable-runtime-cpu-detect"
    end

    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "ar", "-x", "#{lib}/libvpx.a"
  end
end

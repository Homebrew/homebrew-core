class Bgpstream < Formula
  desc "For live and historical BGP data analysis"
  homepage "https://bgpstream.caida.org/"
  url "https://github.com/CAIDA/libbgpstream/releases/download/v2.3.0/libbgpstream-2.3.0.tar.gz"
  sha256 "c6be2c761ed216edc23a85409a5de3639172bc42db115c8574c2108ace7481a4"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c060368caac64c91df708d5b62f1e5ff276d94447b98c59cd168a0158890d1e2"
    sha256 cellar: :any,                 arm64_sequoia:  "8db317338ecbca23c82ea862d2f50c557262929d5c805abe88cf601dd5377da5"
    sha256 cellar: :any,                 arm64_sonoma:   "cad6544e83d2f83c50c324be9e81d144afd00e75f92d96f007dd131f529e1164"
    sha256 cellar: :any,                 arm64_ventura:  "dde80cac2798151d197586224462134faaa3f2e4504f7385bd63679326851646"
    sha256 cellar: :any,                 arm64_monterey: "b693ea06d316782ba814fe4e5580f9c3be901cefb5a1dd8fdd5ccab71a342d96"
    sha256 cellar: :any,                 sonoma:         "a4aef360bb939d7ed5f7eef8e25248480b23af24914d8493af34fd9dc64478b4"
    sha256 cellar: :any,                 ventura:        "66b080b4aa838bc8d49618e17dba64817b0a02f3b66ec187a1ff554e9f50a246"
    sha256 cellar: :any,                 monterey:       "62c0565e4e317bb7a687f093b19830272088eb1ab00cde9f6160ca99b45f489e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "87a539b41d619711093bbd3fb76e30d78feaa1d4ff134f26afe6e0ac15263b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb6547761ec1c1a5b8bd0c71899bc0c7acf4316c2d9c109b7ac66754c26d6341"
  end

  depends_on "librdkafka"
  depends_on "wandio"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "bgpstream.h"
      int main()
      {
        bgpstream_t *bs = bs = bgpstream_create();
        if(!bs) {
          return -1;
        }
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbgpstream", "-o", "test"
    system "./test"
  end
end

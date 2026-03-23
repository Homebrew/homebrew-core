class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "https://sourceforge.net/projects/faac/"
  url "https://github.com/knik0/faac/archive/refs/tags/faac-1.40.tar.gz"
  sha256 "3ef4cc1fa6a750003602adc6eea892ca3815becd9145797b787f0999e8b2b89c"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/knik0/faac.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "328ea5edf8aed0c2924d466aa547ecf361bb4329601eb0b46cdec7cadcc684f7"
    sha256 cellar: :any,                 arm64_sequoia: "8e645259e46b7f9da1ed54e0ddc3dc8ab059148d2bef398eedb5545942c9b181"
    sha256 cellar: :any,                 arm64_sonoma:  "e2e624769511e047231361cb3c7b6997b2952c4902b224ffd40b5e0cc6031eb8"
    sha256 cellar: :any,                 sonoma:        "83dbb04d3aa70aa85260ff1f8a80b35a1b9261d44a300efad76658ba49872bb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dc2fd31acbc1b6ab2272283143a64d17a7ef9155a1d83d95ce82a31041c4155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db68453ac31bbde0615ad36cd30214c019d5a718769f1febe5c8952220ea29c7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert_path_exists testpath/"test.m4a"
  end
end

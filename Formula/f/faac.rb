class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "https://sourceforge.net/projects/faac/"
  url "https://github.com/knik0/faac/archive/refs/tags/faac-1.50.tar.gz"
  sha256 "e6876cba00cbd786a7f984d9aaada4d5bcb08d2582100366c70f6164d5c89214"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/knik0/faac.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a574ca25f086a26e78bbba85083d08fba1625eac583926ea225e21abb96c58de"
    sha256 cellar: :any,                 arm64_sequoia: "14b4c7d0d9a3eff2134d38f3a0390f571ec592963a0b01c2a5d8194e71bae1e6"
    sha256 cellar: :any,                 arm64_sonoma:  "0c750f3bba82d9544c35948c11097b9d9ede18c93fe61877fd0cbc5454a9e4f2"
    sha256 cellar: :any,                 sonoma:        "c08f8b6e2c50c8d85b7e48c1e255227d395b9518a1e37d52c4e05969e9e25ae3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16831fe3c0506720985abc848a75ff201f4c80b378083858289b6615ca2e5b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80d3a04f6c8279bcaa77e91c22ded1d4b37d414d3d4476189cfe7ba5c5f49efa"
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

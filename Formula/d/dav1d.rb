class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/1.5.5/dav1d-1.5.5.tar.bz2"
  sha256 "afc5378daba30eafd11d7b4f0ec863270d7b175f38393a2e1e0ff76f3a45c8b9"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    manifest_sha256 "c6738c15b8babca1c68e7eab4743f66a6bbc0a47994d5d2d7e5976f08bca9af6"
    sha256 cellar: :any, arm64_golden_gate: "824ec3f105944cdd7093689462715263a67e77c5ba1b40b9f89ad519389c5232"
    sha256 cellar: :any, arm64_tahoe:       "b6d59d5f336a5f3b053e5e4de4aecd17c0d6c2a6e38e116fa5803241f7af1019"
    sha256 cellar: :any, arm64_sequoia:     "fb6c682102acf636d05f80ce535e9dbc3963d3940051c27fb1c51dd526b4a125"
    sha256 cellar: :any, arm64_linux:       "fb752ed4ff2fe2d608d38728bdc341e8162a86a071915ea24eacb3da6b7e16cf"
    sha256 cellar: :any, x86_64_linux:      "04635411a388d6c4570fd0d0276520b18f407fc023100829d8b4f82a7cd72b24"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  resource "homebrew-00000000.ivf", :test do
    url "https://code.videolan.org/videolan/dav1d-test-data/raw/1.1.0/8-bit/data/00000000.ivf"
    sha256 "52b4351f9bc8a876c8f3c9afc403d9e90f319c1882bfe44667d41c8c6f5486f3"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    testpath.install resource("homebrew-00000000.ivf")
    system bin/"dav1d", "-i", testpath/"00000000.ivf", "-o", testpath/"00000000.md5"

    assert_path_exists (testpath/"00000000.md5")
    assert_match "0b31f7ae90dfa22cefe0f2a1ad97c620", (testpath/"00000000.md5").read
  end
end

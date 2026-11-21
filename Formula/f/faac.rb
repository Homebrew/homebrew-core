class Faac < Formula
  desc "ISO AAC audio encoder and decoder suite with MP4 muxer and resampler"
  homepage "https://freewareadvancedaudio.github.io"
  url "https://github.com/FreewareAdvancedAudio/faac/archive/refs/tags/faac-3.0.tar.gz"
  sha256 "b46e1431d0c10f97767e058fbe782744fef23bc7b3fc8be0e9751558d506565f"
  license "LGPL-2.1-or-later"
  compatibility_version 3
  head "https://github.com/FreewareAdvancedAudio/faac.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "73cdcc4e8d2070975401d05242081e54c6b1f08e30e07c1a994177367af07342"
    sha256 cellar: :any, arm64_tahoe:       "2e8407cca363bf76535a0cc71a2a705655eb6b8ebf5855a9e791b039b94eb0a8"
    sha256 cellar: :any, arm64_sequoia:     "4cc581a53c9602b258a29b07723b453e884d85e0b82dc7f756563317f54d6305"
    sha256 cellar: :any, arm64_linux:       "22d9ba59a47291063e0acd09bbd20fd4ddf4115708b6b9e2f8a94b985535916b"
    sha256 cellar: :any, x86_64_linux:      "843f94b10755fef5317b0f31ac021632c4ce8f9e71bd6152e4cd70c27c7f6fb6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  link_overwrite "bin/faad", "share/man/man1/faad.1"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    cp test_fixtures("test.wav"), testpath/"in.wav"
    system bin/"faac", "-b", "32", "in.wav", "-o", "out.m4a"
    assert_path_exists testpath/"out.m4a"

    system bin/"faad", "-o", "back.wav", "out.m4a"
    assert_path_exists testpath/"back.wav"

    system bin/"faam", "info", "out.m4a"

    system bin/"faar", "-r", "48000", "in.wav", "re.wav"
    assert_path_exists testpath/"re.wav"
  end
end

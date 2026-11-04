class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "https://www.vervest.org/htp/"
  url "https://github.com/twekkel/htpdate/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "92a787338666d02d5b871444de5b0d5128f789d041342204f9c9837309da8080"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c19851f27f2b44bdbe96c7bce23c908813692604d84a88c508b10907255bcf6f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c79aeaa809a1a655acfb947efbf82b08e05ab7129253c54876088713ef0fdb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f125ebdf91cebf9321a700da992c6e9521bc1c658a751cf6c8bcf841b0f8c9e2"
    sha256 cellar: :any,                 arm64_linux:       "cbdb3d9d6c1b5ebe0d3c4ddab0bc09859b211ee28d22e91a4fc2c905183956f2"
    sha256 cellar: :any,                 x86_64_linux:      "6d9728c52b94d93db11904cff17a18df6ac4c4c3ad6bf145f50cc6b4f880da12"
  end

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system sbin/"htpdate", "-q", "-d", "-u", ENV["USER"], "example.org"
  end
end

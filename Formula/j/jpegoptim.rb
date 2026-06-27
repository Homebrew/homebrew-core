class Jpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "661a808dfffa933d78c6beb47a2937d572b9f03e94cbaaab3d4c0d72f410e9be"
  license "GPL-3.0-or-later"
  head "https://github.com/tjko/jpegoptim.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "17b597c1c3a8a0d3ed76c1b01e068e9922d0dc2242c92494e88ab25a53da0c76"
    sha256 cellar: :any,                 arm64_sequoia: "03905aa303c9a5d5b6669cac8f0c4f46fbf4fe3f54ede70d9bc8d958a1e486b3"
    sha256 cellar: :any,                 arm64_sonoma:  "6db9dfc80fb96a601bca0a090651dfae9725eccb54bfafd262da733b45f75ef8"
    sha256 cellar: :any,                 sonoma:        "b2aafb2a469573baffe37024b1086c2b04512e2f3087c1c70100533e3733f866"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd0b242dd53f3b2bfce6c34f065b399ced6b8452225df225e1655c42cf848efd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44cf0605e6d6dc761b5e75770b2534c52da44bfdb0aa913d8841933aa7db35fb"
  end

  depends_on "jpeg-turbo"

  def install
    system "./configure", *std_configure_args
    ENV.deparallelize # Install is not parallel-safe
    system "make", "install"
  end

  test do
    source = test_fixtures("test.jpg")
    assert_match "OK", shell_output("#{bin}/jpegoptim --noaction #{source}")
  end
end

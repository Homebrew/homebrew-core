require "base64"

class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.5.4.tar.gz"
  sha256 "e414f4d08f0069550091a24de188ef7537780f407d76d5c4f1b82b3645a88f8f"

  bottle do
    cellar :any_skip_relocation
    sha256 "d659ec48b4737eea12cafa7db3cbf4ef430246827b00b1a621376ccaa3fd8370" => :catalina
    sha256 "3a268374ec97cfe9f745c8e58e23ad7d1ebe3ef5dc8e6c3a81ea3097d84bd501" => :mojave
    sha256 "c6aa781abc7a8c87f5c376223bf46ad9a178131ce35e428beb1ee39ba77a99d6" => :high_sierra
  end

  # Fixes a redefinition of the uint type, which led to build failures
  # on macOS. Fixed upstream, will be in the next release.
  # https://github.com/jsummers/deark/issues/9
  patch do
    url "https://github.com/jsummers/deark/commit/0fe5528c38f9b63d8fbaafcf57ac31ada0dbb5ff.patch?full_index=1"
    sha256 "a85b552d2908eaa458e3ed8dc462651e98286c1c817408eafea74df5c41dfb7d"
  end

  def install
    system "make"
    bin.install "deark"
  end

  test do
    (testpath/"test.gz").write ::Base64.decode64 <<~EOS
      H4sICKU51VoAA3Rlc3QudHh0APNIzcnJ11HwyM9NTSpKLVfkAgBuKJNJEQAAAA==
    EOS
    system "#{bin}/deark", "test.gz"
    file = (testpath/"output.000.test.txt").readlines.first
    assert_match "Hello, Homebrew!", file
  end
end

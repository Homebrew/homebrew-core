require "base64"

class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.5.4.tar.gz"
  sha256 "e414f4d08f0069550091a24de188ef7537780f407d76d5c4f1b82b3645a88f8f"

  bottle do
    cellar :any_skip_relocation
    sha256 "aee57506ce46b2e68ac24bf69ad34e2064995d4f48a56e6cde455fa03bfd36b9" => :catalina
    sha256 "12b0fda7a6b6030ef70c3a06985581a989fad1e12baa692fc41fb6b7827890bd" => :mojave
    sha256 "94718e3c67b4f3044518fcff031f194c6a3daa24ce36cd416842f441319f877a" => :high_sierra
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

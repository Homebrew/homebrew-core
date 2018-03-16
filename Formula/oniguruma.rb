class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.8.0/onig-6.8.0.tar.gz"
  sha256 "c9cd7b50f96460a8f5823f5916f57038c24cfb0d8e3bb86b8bb8b990daa4755c"

  bottle do
    cellar :any
    sha256 "ffec194130c7a2938a41c86ebaccc63f81439447bc3e46814e5f1daf3add7ad4" => :high_sierra
    sha256 "322159ae599babc31b4d5d4af0b2697d5e888e116e0da3998b0d9caf1a9d3942" => :sierra
    sha256 "ce043684f028f8899386abc13b746d0e86de1340bacf145bd25469e104a3d376" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end

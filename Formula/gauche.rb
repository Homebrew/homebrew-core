class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://downloads.sourceforge.net/gauche/Gauche/Gauche-0.9.7.tgz"
  sha256 "2d33bd942e3fc2f2dcc8e5217c9130c885a0fd1cb11a1856e619a83a23f336a0"

  bottle do
    sha256 "5f9d4bd0bfa7bbae0636ec38ec5b7161ed3331f2ae19fe03c9b37f3999b0f3f8" => :mojave
    sha256 "bc91cda4955fee0688f538c74b3778a9209ce125609e2c475541dc068cdfdabd" => :high_sierra
    sha256 "b5a7a0af54112b6e3940c5fc4a0684f1d70105103fcfae2e72010d4710949c07" => :sierra
    sha256 "fda2066f1a651e0beaac3e4980819064d2206578a040cebb703dd77e803d5635" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--enable-multibyte=utf-8"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "Gauche scheme shell, version #{version}", output
  end
end

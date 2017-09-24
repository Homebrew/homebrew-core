class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://downloads.sourceforge.net/gauche/Gauche/Gauche-0.9.5.tgz"
  sha256 "4c8a53213de112708bbda5fa9648c21497d43ebf809ed5b32b15f21266b4e73c"

  bottle do
    sha256 "7833855dcc680ac0617171d68bb063a193d74e3133f12bd06a01dd221201fa51" => :high_sierra
    sha256 "0bfbcbb0f5066b939712e3eed33f0ed221f1e6ba096aca95bc6ad1d69b92c74d" => :sierra
    sha256 "2959fc3962fe83ac5d66f522d0be8b5abb7d86f43594c47b0ea34bf9c4db7e5d" => :el_capitan
    sha256 "31baa1ce9e676f98f708b9d2ec84fdeab7ca8a61a7153c90fefc120fd298b66c" => :yosemite
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

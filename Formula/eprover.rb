class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "https://eprover.org/"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_2.2/E.tgz"
  sha256 "2c2c45a57e69daa571307a89746228194f0144a5884741f2d487823f1fbf3022"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f45c36c2ba8a4c3793b4078b9948a735853d9e91e568d7a5ffcc2ec195998ca" => :mojave
    sha256 "77cd34eeb515299ddd4f3db8e6fa70580c64b144d9e82718d4e3a5c5b4f7a25a" => :high_sierra
    sha256 "b2ab8b9aaebb1755f8f77c5f1820f795a15c5daa77dd42b718e194404cec70f8" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--man-prefix=#{man1}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/eprover", "--help"
  end
end

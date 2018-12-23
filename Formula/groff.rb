class Groff < Formula
  desc "GNU troff text-formatting system"
  homepage "https://www.gnu.org/software/groff/"
  url "https://ftp.gnu.org/gnu/groff/groff-1.22.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/groff/groff-1.22.4.tar.gz"
  sha256 "e78e7b4cb7dec310849004fa88847c44701e8d133b5d4c13057d876c1bad0293"

  bottle do
    rebuild 1
    sha256 "117230db80bea766e9bdd3f0af02911d824ac333a14c466762ef475dc7ffc5bb" => :mojave
    sha256 "cbcd60c91851bfeb7d32d292bc2f1838ee130b1e9b87c4bac535142b7c8dc4de" => :high_sierra
    sha256 "39945f37f43ad6ad93d87469847dff4d75f720a9209c0e4c5596c61eb611b6ae" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--without-x"
    system "make" # Separate steps required
    system "make", "install"
  end

  test do
    assert_match "homebrew\n",
      pipe_output("#{bin}/groff -a", "homebrew\n")
  end
end

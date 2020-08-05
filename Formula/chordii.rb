class Chordii < Formula
  desc "Text file to music sheet converter"
  homepage "https://www.vromans.org/johan/projects/Chordii/"
  url "https://downloads.sourceforge.net/project/chordii/chordii/4.5/chordii-4.5.3b.tar.gz"
  sha256 "edb19be9de456366e592a75a5ce1c0a75352a55d5b4e5f282c953c7e7f2d87b5"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed1f635a737973af4b9f4f784757cdf0ddbb3f946cb285917c171392a9b59d4a" => :catalina
    sha256 "def6b665fba55dfb8fa30269966e059b0a827f62a2338f73ea89c47a42fa7de7" => :mojave
    sha256 "1901080a06bb4728ec9858e4e548f68e044534b9d65dee1996f0590b56abc1a9" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"homebrew.cho").write <<~EOS
      {title:Homebrew}
      {subtitle:I can't write lyrics. Send help}

      [C]Thank [G]You [F]Everyone,
      [C]We couldn't maintain [F]Homebrew without you,
      [G]Here's an appreciative song from us to [C]you.
    EOS

    system bin/"chordii", "--output=#{testpath}/homebrew.ps", "homebrew.cho"
    assert_predicate testpath/"homebrew.ps", :exist?
  end
end

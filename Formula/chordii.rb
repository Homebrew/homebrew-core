class Chordii < Formula
  desc "Text file to music sheet converter"
  homepage "https://www.vromans.org/johan/projects/Chordii/"
  url "https://downloads.sourceforge.net/project/chordii/chordii/4.5/chordii-4.5.3.tar.gz"
  sha256 "140d24a8bc8c298e8db1b9ca04cf02890951aa048a656adb7ee7212c42ce8d06"

  bottle do
    cellar :any_skip_relocation
    sha256 "21988d35455db7ffdf5106de88aa8ca8690a34e7d5df5f66f0e0c3e3f8544041" => :sierra
    sha256 "0ac1735d61f7843a61e4364bbd6bf955d77046f20f5933b4dfa1c39666e1e595" => :el_capitan
    sha256 "5592e19ddb7affade8a918992648c87bb92a83e201e28f8afdae87e3e3ba4c2b" => :yosemite
    sha256 "f828c0158bfa52c9e136c0332ea595e788af14073082847d51bc4c96e6c909ac" => :mavericks
    sha256 "532cb785f263790e7a314df2a276c2ee73de50fe630df8514586d888c0bb6281" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"homebrew.cho").write <<-EOS.undent
      {title:Homebrew}
      {subtitle:I can't write lyrics. Send help}

      [C]Thank [G]You [F]Everyone,
      [C]We couldn't maintain [F]Homebrew without you,
      [G]Here's an appreciative song from us to [C]you.
    EOS

    system bin/"chordii", "--output=#{testpath}/homebrew.ps", "homebrew.cho"
    assert File.exist?("homebrew.ps")
  end
end

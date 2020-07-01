class Pforth < Formula
  desc "Portable ANS-like Forth written in ANSI C"
  homepage "http://www.softsynth.com/pforth/"
  url "https://github.com/philburk/pforth/archive/d71efe1792a1414a5b102ae8e69f3913c70aa8b0.tar.gz"
  version "28"
  sha256 "f854ebdaed276734fccc503da3e60af867350012caeeac6fffed85e7a8eecb6a"
  head "https://github.com/philburk/pforth.git"

  def install
    cd "build/unix" do
      system "make", "pfdicapp"
      system "make", "pfdicdat"
      system "make", "pforthapp"
      bin.install "pforth_standalone" => "pforth"
    end
  end

  test do
    (testpath/"hello.fth").write <<~EOS
      CR ." HELLO WORLD"
    EOS
    assert_match "HELLO WORLD", shell_output("#{bin}/pforth hello.fth")
  end
end

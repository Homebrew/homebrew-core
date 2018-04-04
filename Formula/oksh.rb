class Oksh < Formula
  desc "The portable version of the OpenBSD Korn shell, a Public Domain shell"
  homepage "https://devio.us/~bcallah/oksh/"
  url "https://devio.us/~bcallah/oksh/oksh-20180111.tar.gz"
  sha256 "c15652b503123dd542144c36f12a076fdb89b1fc4c6a8807ce1ec83fa1e0d797"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    bin.install "oksh"
    man1.install "oksh.1"
  end

  test do
      assert_equal "hello", shell_output("#{bin}/oksh -c \"echo hello\"").strip
  end
end

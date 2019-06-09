class Oksh < Formula
  desc "Portable OpenBSD Korn Shell"
  homepage "https://github.com/ibara/oksh"
  url "https://github.com/ibara/oksh/releases/download/oksh-6.5/oksh-6.5.tar.gz"
  sha256 "2adf52ab718249462a41e1172d0bfb8670731daa0618e560be58064cac23a0bd"

  head "https://github.com/ibara/oksh.git"

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-curses
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "42", shell_output("#{bin}/oksh -c 'printf 42'").strip
  end
end

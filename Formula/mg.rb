class Mg < Formula
  desc "Small Emacs-like editor"
  homepage "https://github.com/ibara/mg"
  url "https://github.com/ibara/mg/releases/download/mg-6.5/mg-6.5.tar.gz"
  sha256 "3e4bb4582c8d1a72fb798bc320a9eede04f41e7e72a1421193174b1a6fc43cd8"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "8b9e7b59a0021e6bf6e2534f437438fa692f0b9afb68eadf24ec1d2690f1b966" => :catalina
    sha256 "54880473248cbcc31d29cec5e6c053629f47525fd8fdbd3e72310321b2681e04" => :mojave
    sha256 "3eb1ebbc0e3cff3645b5608ed1584a4e78400b3d0e6063667aaac98dd79fa81b" => :high_sierra
    sha256 "6177fdb667f9e016e0c2c87844637bd20630a44f2f3bf4068b0117ecbf72f631" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"command.sh").write <<~EOS
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/mg
      match_max 100000
      send -- "\u0018\u0003"
      expect eof
    EOS
    chmod 0755, testpath/"command.sh"

    system testpath/"command.sh"
  end
end

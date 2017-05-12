class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.29.1/mk-configure-0.29.1.tar.gz"
  sha256 "a675c532f6a857c79dedef2cce4776dda8becfbe7d2126e5f67175aee56c3957"

  depends_on "bmake" => :build
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = prefix.to_s
    ENV["MANDIR"] = man.to_s

    system "bmake", "all"
    system "bmake", "install"
    (share/"doc/mk-configure").install("presentation/presentation.pdf")
  end

  test do
    system "#{bin}/mkcmake", "-V", "MAKE_VERSION", "-f", "/dev/null"
  end
end

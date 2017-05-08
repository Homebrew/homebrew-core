class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "http://sourceforge.net/projects/mk-configure/"
  url "https://sourceforge.net/projects/mk-configure/files/mk-configure/mk-configure-0.29.1/mk-configure-0.29.1.tar.gz"
  sha256 "a675c532f6a857c79dedef2cce4776dda8becfbe7d2126e5f67175aee56c3957"

  depends_on "bmake" => :build
  depends_on "makedepend" => :build
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = "#{prefix}"

    system "bmake"
    system "bmake", "install"
    system "cp", "presentation/presentation.pdf", "#{prefix}/share/doc/mk-configure/"
  end
  
  test do
    system "mkcmake", "-V", "MAKE_VERSION", "-f", "/dev/null"
  end

end

class Binutils < Formula
  desc "FSF Binutils for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/binutils/binutils-2.27.tar.gz"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.gz"
  sha256 "26253bf0f360ceeba1d9ab6965c57c6a48a01a8343382130d1ed47c468a3094f"

  bottle do
    cellar :any if OS.linux?
    sha256 "1293c3cf47169fe0936144e8f7c045b60531ab930ba790f211ac122b5148267a" => :sierra
    sha256 "094dab865dacf4c365a85b0f17e46c8e22621bd36d1e0fbebe42c9c44c66d822" => :el_capitan
    sha256 "18ca38f5b11315bdc250cb684a7f964af58dc8927b4fa1fb83dbc69a7e965060" => :yosemite
    sha256 "f439d283e39ec5ea5f24bd801ad1dbb03df109e8290d75714551dbe034785e7a" => :mavericks
    sha256 "7f47d549f79c74f6fef6442f6562f05b477a0d4304cbe0d76306f07b46969a16" => :x86_64_linux
  end

  # No --default-names option as it interferes with Homebrew builds.
  option "with-default-names", "Do not prepend 'g' to the binary" if OS.linux?

  depends_on "zlib" => :recommended unless OS.mac?

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          ("--program-prefix=g" if build.without? "default-names"),
                          ("--with-sysroot=/" if OS.linux?),
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-targets=all"
    system "make"
    system "make", "install"
  end

  test do
    # Better to check with?("default-names"), but that doesn't work.
    nm = build.with?("default-names") ? "nm" : "gnm"
    assert_match "main", shell_output("#{bin}/#{nm} #{bin}/#{nm}")
  end
end

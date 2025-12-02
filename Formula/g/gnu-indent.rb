class GnuIndent < Formula
  desc "C code prettifier"
  homepage "https://www.gnu.org/software/indent/"
  url "https://ftpmirror.gnu.org/gnu/indent/indent-2.2.13.tar.gz"
  mirror "https://ftp.gnu.org/gnu/indent/indent-2.2.13.tar.gz"
  sha256 "9e64634fc4ce6797b204bcb8897ce14fdd0ab48ca57696f78767c59cae578095"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "9734507ce86daffede4a8529ea0da48daa0993cd639900769d131d677f4d5c64"
    sha256 arm64_sequoia:  "bd0bd4400bed0df025ba9e73add09aaa2c2e4ac341dfcc59d69f1cd4c6394f6a"
    sha256 arm64_sonoma:   "cc9469378596d13d421d77264e388158e614479d88256aab58d812f0746daf8e"
    sha256 arm64_ventura:  "97de44230879e486cbbc8730922fb70228f0fc74875eabc4656fcbf04bf87ec2"
    sha256 arm64_monterey: "959602e650c7712ac037b4cd37b1dcd4adbf237570e55060b32bfe77b51f451d"
    sha256 sonoma:         "08ff0b0519d556b0a9bcb55c6511704c9a0190bb831733c9d0b0342e6cfe42bb"
    sha256 ventura:        "ca896ee13248337aa3cb203b13bfb64a327f7c479aee79977839ab5128183c4a"
    sha256 monterey:       "ecb07ef5d33d1a39f21bf5b8c10fefc41021eaf134979a35173928cc13b6c82f"
    sha256 arm64_linux:    "75f78490b2047df1500e85d9c33ac481815fea272ab7ea3c91358b1d4a3fe48a"
    sha256 x86_64_linux:   "ca7c98aad69c128e21dc47666737ffc57d55118fe1e5e73b4e63874dfb1f6721"
  end

  depends_on "gettext"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE" if OS.mac?
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gindent" => "indent"
      (libexec/"gnuman/man1").install_symlink man1/"gindent.1" => "indent.1"
    end

    (libexec/"gnubin").install_symlink "../gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "indent" has been installed as "gindent".
        If you need to use it as "indent", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    (testpath/"test.c").write("int main(){ return 0; }")
    binary = if OS.mac?
      "#{bin}/gindent"
    else
      "#{bin}/indent"
    end
    system binary, "test.c"
    assert_equal <<~C, File.read("test.c")
      int
      main ()
      {
        return 0;
      }
    C
  end
end

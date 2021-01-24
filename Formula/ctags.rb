class Ctags < Formula
  desc "Reimplementation of ctags(1)"
  homepage "https://ctags.sourceforge.io/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 2

  stable do
    url "https://downloads.sourceforge.net/project/ctags/ctags/5.8/ctags-5.8.tar.gz"
    sha256 "0e44b45dcabe969e0bbbb11e30c246f81abe5d32012db37395eb57d66e9e99c7"

    # also fixes https://sourceforge.net/p/ctags/bugs/312/
    # merged upstream but not yet in stable
    patch :p2 do
      url "https://gist.githubusercontent.com/naegelejd/9a0f3af61954ae5a77e7/raw/16d981a3d99628994ef0f73848b6beffc70b5db8/Ctags%20r782"
      sha256 "26d196a75fa73aae6a9041c1cb91aca2ad9d9c1de8192fce8cdc60e4aaadbcbb"
    end
  end

  livecheck do
    url :stable
    regex(%r{url=.*?/ctags[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "d874d12982113ff0cc79501241b6c5f0caa16ae73821be66a49e246c257ccee5" => :big_sur
    sha256 "d78b7f55870960eb32371500da37e1b74f3d67f63e4b9e3e7fba2040f68f5743" => :arm64_big_sur
    sha256 "0f9bebdadd76a7ec818b904d6266eae183e869bf6f83302d836b93fc50a03714" => :catalina
    sha256 "da05bcfc8536c7e627dbea17e67997b45388706ba9bb84e521682c0358cf18b5" => :mojave
    sha256 "169b9d458f2db04d609c86c36e9d9dd4ee2474b7c472a1a11c766454e4bba1a4" => :high_sierra
  end

  head do
    url "https://svn.code.sf.net/p/ctags/code/trunk"
    depends_on "autoconf" => :build
  end

  # fixes https://sourceforge.net/p/ctags/bugs/312/
  patch :p2 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/ctags/5.8.patch"
    sha256 "9b5b04d2b30d27abe71094b4b9236d60482059e479aefec799f0e5ace0f153cb"
  end

  def install
    if build.head?
      system "autoheader"
      system "autoconf"
    end

    # Work around configure issues with Xcode 12
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-macro-patterns",
                          "--mandir=#{man}",
                          "--with-readlib"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Under some circumstances, emacs and ctags can conflict. By default,
      emacs provides an executable `ctags` that would conflict with the
      executable of the same name that ctags provides. To prevent this,
      Homebrew removes the emacs `ctags` and its manpage before linking.
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>

      void func()
      {
        printf("Hello World!");
      }

      int main()
      {
        func();
        return 0;
      }
    EOS
    system "#{bin}/ctags", "-R", "."
    assert_match /func.*test\.c/, File.read("tags")
    assert_match "+regex", shell_output("ctags --version")
  end
end

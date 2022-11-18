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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1663c12c3c741cbb744beaeeeeef5b149e3683aa62f3bdb41c8516bb161194e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe6b329a45efc1ac2048d4fce13b8fed5758f1814b5cc8a55bd4f542d846b59f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e8ee6051008e73c999dbc8476221f220ef87fdf9cbc409a308df6a956e114e6"
    sha256 cellar: :any_skip_relocation, ventura:        "936d4fd1280ecbcff4c3b07a5af8a07c2115c0ffa36bb7aa4418ac2a23d284f2"
    sha256 cellar: :any_skip_relocation, monterey:       "dac2afa169f02a036b20d719540124fb030d8e3342a754bd6bbb405f94f417ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "9986b3f6897b60cbdf5d73b4ad819d2d30726043dc0d665b77ba2def399a60b4"
    sha256 cellar: :any_skip_relocation, catalina:       "2292b70a7b744c2238507417e40c2dc7273c6d919c9fe037bf668cf00863ad92"
    sha256 cellar: :any_skip_relocation, mojave:         "238b65e5e1614f1d24fd88b6741c04d1cf48fd5f5d247cdbcd1f82d5796197d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8630326626ccee22ad669f9e7c459735a8dc72c765ae40ec218f31e015dc76a"
  end

  head do
    url "https://svn.code.sf.net/p/ctags/code/trunk"
    depends_on "autoconf" => :build
  end

  conflicts_with "universal-ctags", because: "this formula installs the same executable as the ctags formula"

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
    assert_match(/func.*test\.c/, File.read("tags"))
    assert_match "+regex", shell_output("ctags --version")
  end
end

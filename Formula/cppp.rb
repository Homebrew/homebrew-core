class Cppp < Formula
  desc "Partial Preprocessor for C"
  homepage "http://www.muppetlabs.com/~breadbox/software/cppp.html"
  url "http://www.muppetlabs.com/~breadbox/pub/software/cppp-2.6.tar.gz"
  sha256 "d42cd410882c3b660c77122b232f96c209026fe0a38d819c391307761e651935"

  def install
    system "make"
    bin.install "cppp"
  end

  test do
    (testpath/"hello.c").write <<-EOS.undent
    /* Comments stand for code */
    #ifdef FOO
    /* FOO is defined */
    # ifdef BAR
    /* FOO & BAR are defined */
    # else
    /* BAR is not defined */
    # endif
    #else
    /* FOO is not defined */
    # ifndef BAZ
    /* FOO & BAZ are undefined */
    # endif
    #endif
    EOS
    system "#{bin}/cppp", "-DFOO", "hello.c"
  end
end

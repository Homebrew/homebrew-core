class Cppp < Formula
  desc "Partial Preprocessor for C"
  homepage "http://www.muppetlabs.com/~breadbox/software/cppp.html"
  url "http://www.muppetlabs.com/~breadbox/pub/software/cppp-2.6.tar.gz"
  sha256 "d42cd410882c3b660c77122b232f96c209026fe0a38d819c391307761e651935"

  bottle do
    cellar :any_skip_relocation
    sha256 "af58094ee1d80d6d09163b42755d827aa5b8be15b636a6ad087b334978ad2e38" => :sierra
    sha256 "3bb773301b97402f783e506f3ccc339d7363df6e292d255d6b3209e5be8d1c1a" => :el_capitan
    sha256 "7c18c1844a89ca3a0ee7084b06c908de2288378eaeac09c7872b0eae97129fc3" => :yosemite
    sha256 "2765ea90bea4f32ba431ef1f53699a61c2abaf0d3035ed32fb579d42794c9567" => :mavericks
  end

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

class CsvFix < Formula
  desc "Tool for manipulating CSV data"
  homepage "https://neilb.bitbucket.io/csvfix/"
  url "https://bitbucket.org/neilb/csvfix/get/version-1.6.tar.gz"
  sha256 "32982aa0daa933140e1ea5a667fb71d8adc731cc96068de3a8e83815be62c52b"

  bottle do
    cellar :any_skip_relocation
    sha256 "3cc10313342650c680f23241e19ff8ec6b64df8fcc2123c5161b15e992c8973b" => :catalina
    sha256 "93a9586c3ef8614be909c0e5ac5bb463536dab6fcbfc00bb1e94fc6affbe7248" => :mojave
    sha256 "e02b2cb8929617c91a258c313481097146259a9ed68094bd759c30c3cc75806e" => :high_sierra
    sha256 "b52224f7cd1dd228ffe751c67993f854a8a59f17d6099d40fca02374f1949d02" => :sierra
    sha256 "ba19053a978b57b6b962f8fa24d099d964ceb90cd28304e3a6c2a7fe0d3abc32" => :el_capitan
    sha256 "b8dbaf2e14e35cc4c1d7b5d04a5615377f7eeb4d9b1f25fe554b8711511c28f6" => :yosemite
    sha256 "0b86933c8e32830d5abd0f26ef83b1a60e0254da67542b695fd50ab1e3ba2e68" => :mavericks
  end

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    system "make", "lin"
    bin.install "csvfix/bin/csvfix"
  end

  test do
    assert_equal '"foo","bar"',
                 pipe_output("#{bin}/csvfix trim", "foo , bar \n").chomp
  end
end

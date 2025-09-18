class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-8.7.tar.gz"
  sha256 "888a31631a7a70308bb2f333e077d0416f4bb78317f8697ffb4a95187f677301"
  license "W3C"

  livecheck do
    url :homepage
    regex(/href=.*?html-xml-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "805c56aa869cb7f89d9fc11cd1edb4913d9bf76e5c4911d0c59bc9ce77b47a74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bd647931de55d7910433f203fca693d2deeb2c80bc5190464b56cc2d9cd0bc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae39f3f7704ef5261b41cbddbb1facefde3b3224d12d91ec722a243c11d5cafd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72ded5b4323716b813c46b80f31f4604fe7bc7611c5795c865bfc68f4a9ad9bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef5904e06e9a4f2381485ae3ff342d68a6dced43269a9c9098bdfc19503ca08e"
    sha256 cellar: :any_skip_relocation, ventura:       "af7e2d3010b2a13594f27ad96dc45c8a59ada49610aabf24761cb72a210a52ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63363ff100b473875d5af798b0085b7467363f147bc3d793807f1cb37a6b2192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f555fdca29f038169dc2499fc0e680e40c30b18b4224b43b3cc7ac5967bef21c"
  end

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize # install is not thread-safe
    system "make", "install"
  end

  test do
    assert_equal "&#20320;&#22909;", pipe_output("#{bin}/xml2asc", "你好")
  end
end

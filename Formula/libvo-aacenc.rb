class LibvoAacenc < Formula
  desc "VisualOn AAC encoder library"
  homepage "https://opencore-amr.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/opencore-amr/vo-aacenc/vo-aacenc-0.1.3.tar.gz"
  sha256 "e51a7477a359f18df7c4f82d195dab4e14e7414cbd48cf79cc195fc446850f36"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/vo-aacenc[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0f29497bb74d3fb95f6197085ff4894d2cffb6b6cbc92beb43131bbdc088824b"
    sha256 cellar: :any,                 arm64_monterey: "f25bbd61ab93bfe115c37ad611aad07bf0c553903078748803a813e907a783c1"
    sha256 cellar: :any,                 arm64_big_sur:  "cfc4dceab7f9a4a3037e00b26e046f310580ee5aa95906396052b91e22c89231"
    sha256 cellar: :any,                 ventura:        "5c092be2b303fc7bc9c5ce9b56a5cb71987186d5c23e9b8577a502d37b5cc34e"
    sha256 cellar: :any,                 monterey:       "3a4d5c0bc8e920fbeaee283bdf464f37c333e6aa0d0a7b88c4f7535cbf0e44c2"
    sha256 cellar: :any,                 big_sur:        "4776106dbfb4f81523750d6540847a16c74c4e97ed8271bb9e5ab592386310b9"
    sha256 cellar: :any,                 catalina:       "144e0c345d0567a74aba09cfec49fba8f409e2db5abcee96b598127cc5d722ad"
    sha256 cellar: :any,                 mojave:         "099ac7d191241c476ab4ba7375dd05e2d965adc6a7638cc616a99a243cbd077b"
    sha256 cellar: :any,                 high_sierra:    "761ecbbaaa2a944d077040692fc62fe2e929ec788ca7e23b3fb25e6ee1b88d3a"
    sha256 cellar: :any,                 sierra:         "9430e86c9f25aa9fcccf0a19cc6125c9397c23b311b993b1adf83cbe330cd9b4"
    sha256 cellar: :any,                 el_capitan:     "e9a59439f8eec4cdc4d273afb49cbd8f8357862d4d8c7c5d9d9d38588ec6d810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baed718396b9a19dea7de513f7991b72afcb2aae17504a7bbbaf9f0a40d355e4"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <vo-aacenc/cmnMemory.h>

      int main()
      {
        VO_MEM_INFO info; info.Size = 1;
        VO_S32 uid = 0;
        VO_PTR pMem = cmnMemAlloc(uid, &info);
        cmnMemFree(uid, pMem);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lvo-aacenc", "-o", "test"
    system "./test"
  end
end

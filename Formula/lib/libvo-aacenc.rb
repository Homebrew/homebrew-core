class LibvoAacenc < Formula
  desc "VisualOn AAC encoder library"
  homepage "https://opencore-amr.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/opencore-amr/vo-aacenc/vo-aacenc-0.1.3.tar.gz"
  sha256 "e51a7477a359f18df7c4f82d195dab4e14e7414cbd48cf79cc195fc446850f36"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/vo-aacenc[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "86707b69dbdb8c92aa266ebe65b67721e688fcf078e66106a578ddcf0ab6c3f0"
    sha256 cellar: :any,                 arm64_sequoia:  "364ec1b50f38e6b1b0dc5e1ea7b12b624e249aea41810491669c9356ff96feac"
    sha256 cellar: :any,                 arm64_sonoma:   "1e337ddc61248e2bba763f27de3fd1f3699a68e03fdf369e95ef39fd3dd5fac2"
    sha256 cellar: :any,                 arm64_ventura:  "0f29497bb74d3fb95f6197085ff4894d2cffb6b6cbc92beb43131bbdc088824b"
    sha256 cellar: :any,                 arm64_monterey: "f25bbd61ab93bfe115c37ad611aad07bf0c553903078748803a813e907a783c1"
    sha256 cellar: :any,                 arm64_big_sur:  "cfc4dceab7f9a4a3037e00b26e046f310580ee5aa95906396052b91e22c89231"
    sha256 cellar: :any,                 sonoma:         "b41accd6b7a5b2b20f00e998ee9ea3930c09112273e290d4ea7e279b0089a36c"
    sha256 cellar: :any,                 ventura:        "5c092be2b303fc7bc9c5ce9b56a5cb71987186d5c23e9b8577a502d37b5cc34e"
    sha256 cellar: :any,                 monterey:       "3a4d5c0bc8e920fbeaee283bdf464f37c333e6aa0d0a7b88c4f7535cbf0e44c2"
    sha256 cellar: :any,                 big_sur:        "4776106dbfb4f81523750d6540847a16c74c4e97ed8271bb9e5ab592386310b9"
    sha256 cellar: :any,                 catalina:       "144e0c345d0567a74aba09cfec49fba8f409e2db5abcee96b598127cc5d722ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e99e7f98b9c8754ad124303c8cd233596755f32f251a49c1ba61a52d8d2808ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baed718396b9a19dea7de513f7991b72afcb2aae17504a7bbbaf9f0a40d355e4"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <vo-aacenc/cmnMemory.h>

      int main()
      {
        VO_MEM_INFO info; info.Size = 1;
        VO_S32 uid = 0;
        VO_PTR pMem = (VO_PTR)cmnMemAlloc(uid, &info);
        cmnMemFree(uid, pMem);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lvo-aacenc", "-o", "test"
    system "./test"
  end
end
